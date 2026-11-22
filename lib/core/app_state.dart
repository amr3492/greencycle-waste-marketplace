/// Application state, exposed to the widget tree through [AppScope].
///
/// Holds the signed-in user, wallet, cart, orders, recycling stats and
/// the simulated smart-bin loop state. All mutations go through async
/// actions that call the [MockBackend], mirroring real API usage.
library;

import 'dart:math';

import 'package:flutter/widgets.dart';

import 'mock_backend.dart';
import 'models.dart';

/// Points to EGP conversion: 100 eco-points = EGP 10 (deck: points are
/// redeemable for vouchers or cash).
const double egpPerPoint = 0.10;

class AppState extends ChangeNotifier {
  AppState({MockBackend? backend}) : backend = backend ?? MockBackend();

  final MockBackend backend;

  AppUser? currentUser;

  final walletPoints = ValueNotifier<int>(0);
  int _points = 0;
  double _walletEgp = 0;

  int get points => _points;
  double get walletEgp => _walletEgp;

  final txns = <WalletTransaction>[];
  final redemptions = <Redemption>[];
  final records = <WasteRecord>[];
  final cart = <CartLine>[];

  List<SmartBin> bins = [];
  List<MarketplaceItem> items = [];
  List<Voucher> vouchers = [];
  List<Order> myOrders = [];
  List<EmployeeTask> employeeTasks = [];

  bool busy = false;

  int _txnSeq = 0;
  final _rng = Random();

  double get totalRecycledKg =>
      records.fold(0.0, (sum, r) => sum + r.weightKg);

  /// Rough CO2 saving estimate: 1.5 kg CO2 avoided per recycled kg.
  double get co2SavedKg => totalRecycledKg * 1.5;

  Map<WasteCategory, int> get depositCounts {
    final counts = {for (final c in WasteCategory.values) c: 0};
    for (final r in records) {
      counts[r.category] = counts[r.category]! + 1;
    }
    return counts;
  }

  void _setBusy(bool v) {
    busy = v;
    notifyListeners();
  }

  void _addTxn(TxnKind kind, String label,
      {int points = 0, double egp = 0}) {
    _points += points;
    _walletEgp += egp;
    txns.insert(
      0,
      WalletTransaction(
        id: 'txn-${_txnSeq++}',
        kind: kind,
        label: label,
        pointsDelta: points,
        egpDelta: egp,
        at: DateTime.now(),
      ),
    );
  }

  // ---------------------------------------------------------------- Auth ---

  Future<void> login(String email, String password) async {
    _setBusy(true);
    try {
      currentUser = await backend.login(email, password);
      await _loadHomeData();
      // Welcome bonus on first sign-in of a demo session.
      if (_points == 0 && txns.isEmpty) {
        _addTxn(TxnKind.bonus, 'Welcome bonus', points: 120);
      }
    } finally {
      _setBusy(false);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    _setBusy(true);
    try {
      currentUser = await backend.register(
          name: name, email: email, password: password, role: role);
      await _loadHomeData();
      _addTxn(TxnKind.bonus, 'Welcome bonus', points: 120);
    } finally {
      _setBusy(false);
    }
  }

  void signOut() {
    currentUser = null;
    _points = 0;
    _walletEgp = 0;
    txns.clear();
    redemptions.clear();
    records.clear();
    cart.clear();
    myOrders = [];
    notifyListeners();
  }

  Future<void> _loadHomeData() async {
    bins = await backend.fetchBins();
    items = await backend.fetchMarketplace();
    vouchers = backend.vouchers;
    if (currentUser != null) {
      myOrders = await backend.fetchOrders(currentUser!.id);
    }
    if (currentUser?.role == UserRole.employee) {
      employeeTasks = await backend.fetchEmployeeTasks();
    }
    notifyListeners();
  }

  Future<void> refresh() => _loadHomeData();

  // ------------------------------------------------------------- Recycle ---

  /// Runs the simulated AI classification + deposit loop and credits the
  /// wallet instantly (deck: "instant wallet point addition").
  Future<WasteRecord> deposit({
    required String binId,
    required WasteCategory category,
  }) async {
    final record = await backend.classifyAndDeposit(
        binId: binId, requested: category);
    records.add(record);
    _addTxn(
      TxnKind.deposit,
      'Recycled ${record.category.label} at $binId',
      points: record.pointsEarned,
    );
    bins = await backend.fetchBins();
    notifyListeners();
    return record;
  }

  // ---------------------------------------------------------------- Cart ---

  void addToCart(MarketplaceItem item, double qty) {
    final existing = cart.where((l) => l.item.id == item.id).firstOrNull;
    if (existing != null) {
      existing.qty += qty;
    } else {
      cart.add(CartLine(item: item, qty: qty));
    }
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    cart.removeWhere((l) => l.item.id == itemId);
    notifyListeners();
  }

  void setCartQty(String itemId, double qty) {
    final line = cart.firstWhere((l) => l.item.id == itemId);
    line.qty = qty.clamp(0.5, line.item.stockKg);
    notifyListeners();
  }

  double get cartTotal => cart.fold(0.0, (sum, l) => sum + l.total);

  Future<Order> checkout({
    required PaymentMethod method,
    String? cardNumber,
    String? expiry,
    String? cvv,
  }) async {
    _setBusy(true);
    try {
      String? token;
      if (method == PaymentMethod.visa) {
        final result = await backend.authorizeCard(
          cardNumber: cardNumber ?? '',
          expiry: expiry ?? '',
          cvv: cvv ?? '',
        );
        if (!result.success) {
          throw PaymentException(result.error ?? 'Payment failed.');
        }
        token = result.token;
      }
      final order = await backend.placeOrder(
        buyerId: currentUser!.id,
        lines: cart,
        method: method,
        paymentToken: token,
      );
      cart.clear();
      myOrders = await backend.fetchOrders(currentUser!.id);
      return order;
    } finally {
      _setBusy(false);
    }
  }

  // ------------------------------------------------------------- Rewards ---

  Future<Redemption> redeemVoucher(Voucher voucher) async {
    if (_points < voucher.pointsCost) {
      throw StateError('Not enough eco-points for this reward.');
    }
    final code =
        'GC-${voucher.sponsor.substring(0, 3).toUpperCase()}-${1000 + _rng.nextInt(9000)}';
    final redemption =
        Redemption(voucher: voucher, code: code, at: DateTime.now());
    redemptions.add(redemption);
    _addTxn(TxnKind.redemption, 'Redeemed ${voucher.title}',
        points: -voucher.pointsCost);
    notifyListeners();
    return redemption;
  }

  /// Convert eco-points to wallet cash (deck: "vouchers or cash").
  void cashOut(int pointsToConvert) {
    if (pointsToConvert <= 0 || pointsToConvert > _points) {
      throw StateError('Invalid amount.');
    }
    final egp = pointsToConvert * egpPerPoint;
    _addTxn(TxnKind.cashOut, 'Converted points to cash',
        points: -pointsToConvert, egp: egp);
    notifyListeners();
  }

  // ---------------------------------------------------- Employee / Admin ---

  Future<void> advanceTask(String taskId) async {
    await backend.advanceTask(taskId);
    employeeTasks = await backend.fetchEmployeeTasks();
    bins = await backend.fetchBins();
    notifyListeners();
  }

  Future<void> adminSetPrice(String itemId, double newPrice) async {
    await backend.adminSetPrice(itemId, newPrice);
    items = await backend.fetchMarketplace();
    notifyListeners();
  }
}

/// Lightweight inherited widget so the whole tree can reach [AppState]
/// without extra packages.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!.notifier!;
  }

  /// Non-listening lookup for event handlers.
  static AppState read(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<AppScope>();
    final scope = element?.widget as AppScope?;
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!.notifier!;
  }
}
