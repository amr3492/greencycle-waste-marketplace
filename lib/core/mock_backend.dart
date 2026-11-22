/// Mock backend implementing the deck's Tier-2 "Core Application Layer".
///
/// Every method behaves like a real API call (async with simulated
/// latency) so the UI code is identical to what a real backend would use.
/// Swap this class for an HTTP client talking to `server/server.js`
/// (the bundled Node mock API) without touching the UI.
library;

import 'dart:math';

import 'models.dart';

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}

class PaymentException implements Exception {
  PaymentException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Result of the simulated payment gateway (deck: Payment Gateway slide).
class PaymentResult {
  const PaymentResult({required this.success, this.token, this.error});
  final bool success;

  /// "'Payment Successful' token" from the deck's sequence diagram.
  final String? token;
  final String? error;
}

class MockBackend {
  MockBackend() {
    _seed();
  }

  final _rng = Random(42);
  int _seq = 1000;
  String _nextId(String prefix) => '$prefix-${_seq++}';

  static const _latency = Duration(milliseconds: 350);
  Future<T> _delay<T>(T value) => Future.delayed(_latency, () => value);

  final users = <AppUser>[];
  final bins = <SmartBin>[];
  final items = <MarketplaceItem>[];
  final vouchers = <Voucher>[];
  final orders = <Order>[];
  final records = <WasteRecord>[];
  final tasks = <EmployeeTask>[];

  /// Very small demo-grade hash (NOT cryptographic). Documented in README.
  static String hashPassword(String password) {
    var h = 0x811c9dc5;
    for (final c in password.codeUnits) {
      h ^= c;
      h = (h * 0x01000193) & 0x7fffffff;
    }
    return 'fnv1a-${h.toRadixString(16)}';
  }

  // ---------------------------------------------------------------- Auth ---

  Future<AppUser> login(String email, String password) async {
    final normalized = email.trim().toLowerCase();
    final user = users.where((u) => u.email == normalized).firstOrNull;
    if (user == null) {
      throw AuthException('No account found for this email.');
    }
    if (user.passwordHash != hashPassword(password)) {
      throw AuthException('Wrong password. Please try again.');
    }
    return _delay(user);
  }

  /// Deck activity diagram: validates credentials and checks email
  /// uniqueness before creating the account.
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final normalized = email.trim().toLowerCase();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalized)) {
      throw AuthException('Please enter a valid email address.');
    }
    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters.');
    }
    if (users.any((u) => u.email == normalized)) {
      throw AuthException('This email is already registered.');
    }
    final user = AppUser(
      id: _nextId('user'),
      name: name.trim(),
      email: normalized,
      role: role,
      passwordHash: hashPassword(password),
    );
    users.add(user);
    return _delay(user);
  }

  // ---------------------------------------------------------------- Bins ---

  Future<List<SmartBin>> fetchBins() => _delay(List.unmodifiable(bins));

  SmartBin? findBinByQr(String code) {
    final normalized = code.trim().toUpperCase();
    for (final b in bins) {
      if (b.qrCode.toUpperCase() == normalized) return b;
    }
    return null;
  }

  /// The smart-bin AI loop, simulated exactly as the deck presents it:
  /// camera capture -> cloud AI classification -> motor flap actuation ->
  /// points added. [requested] is the waste type the user picked; the
  /// "AI" confirms it with a realistic confidence score.
  Future<WasteRecord> classifyAndDeposit({
    required String binId,
    required WasteCategory requested,
  }) async {
    final confidence = 0.90 + _rng.nextDouble() * 0.099;
    final record = WasteRecord(
      id: _nextId('rec'),
      binId: binId,
      category: requested,
      confidence: confidence,
      pointsEarned: requested.pointsPerItem,
      weightKg: requested.avgWeightKg,
      at: DateTime.now(),
    );
    records.add(record);
    final bin = bins.firstWhere((b) => b.id == binId);
    bin.fillLevels[requested] =
        (bin.fillLevels[requested]! + 0.02).clamp(0.0, 1.0);
    return _delay(record);
  }

  // --------------------------------------------------------- Marketplace ---

  Future<List<MarketplaceItem>> fetchMarketplace() =>
      _delay(List.unmodifiable(items));

  Future<Order> placeOrder({
    required String buyerId,
    required List<CartLine> lines,
    required PaymentMethod method,
    String? paymentToken,
  }) async {
    if (lines.isEmpty) throw PaymentException('Your cart is empty.');
    for (final line in lines) {
      if (line.qty > line.item.stockKg) {
        throw PaymentException('Not enough stock for ${line.item.title}.');
      }
    }
    for (final line in lines) {
      line.item.stockKg -= line.qty;
    }
    final order = Order(
      id: _nextId('ORD'),
      buyerId: buyerId,
      lines: List.of(lines),
      totalEgp: lines.fold<double>(0, (sum, l) => sum + l.total),
      paymentMethod: method,
      status: OrderStatus.pending,
      placedAt: DateTime.now(),
      timeline: {OrderStatus.pending: DateTime.now()},
    );
    orders.add(order);
    // Auto-assign a delivery task to the employee role.
    tasks.add(EmployeeTask(
      id: _nextId('task'),
      kind: TaskKind.delivery,
      title: 'Deliver order ${order.id}',
      area: 'Customer address - Cairo',
      status: TaskStatus.assigned,
      orderId: order.id,
    ));
    return _delay(order);
  }

  Future<List<Order>> fetchOrders(String buyerId) => _delay(
        orders.where((o) => o.buyerId == buyerId).toList()
          ..sort((a, b) => b.placedAt.compareTo(a.placedAt)),
      );

  // ------------------------------------------------------------- Payment ---

  /// Simulated external payment gateway from the deck's sequence diagram:
  /// verifies the card and returns a success token, or asks the user to
  /// "Try Another Card" on failure.
  ///
  /// Demo cards: any Visa-style number passes except one ending in 0000.
  Future<PaymentResult> authorizeCard({
    required String cardNumber,
    required String expiry,
    required String cvv,
  }) async {
    final digits = cardNumber.replaceAll(' ', '');
    if (digits.length != 16 || int.tryParse(digits) == null) {
      return const PaymentResult(
          success: false, error: 'Invalid card number.');
    }
    if (cvv.length != 3) {
      return const PaymentResult(success: false, error: 'Invalid CVV.');
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(expiry)) {
      return const PaymentResult(
          success: false, error: 'Invalid expiry (MM/YY).');
    }
    if (digits.endsWith('0000')) {
      return const PaymentResult(
          success: false,
          error: 'Card declined. Please try another card.');
    }
    return _delay(PaymentResult(
        success: true, token: 'pay_tok_${_rng.nextInt(999999)}'));
  }

  // ------------------------------------------------------------ Employee ---

  Future<List<EmployeeTask>> fetchEmployeeTasks() =>
      _delay(List.unmodifiable(tasks));

  /// Employee advances a task; deliveries also advance the order timeline.
  Future<void> advanceTask(String taskId) async {
    final task = tasks.firstWhere((t) => t.id == taskId);
    if (task.status == TaskStatus.assigned) {
      task.status = TaskStatus.enRoute;
    } else if (task.status == TaskStatus.enRoute) {
      task.status = TaskStatus.done;
      if (task.kind == TaskKind.binCollection && task.binId != null) {
        final bin = bins.firstWhere((b) => b.id == task.binId);
        for (final c in bin.fillLevels.keys.toList()) {
          bin.fillLevels[c] = 0.0;
        }
        bin.status = BinStatus.online;
      }
      if (task.kind == TaskKind.delivery && task.orderId != null) {
        final order = orders.firstWhere((o) => o.id == task.orderId);
        order.status = OrderStatus.delivered;
        order.timeline[OrderStatus.delivered] = DateTime.now();
      }
    }
    return _delay(null);
  }

  /// Admin catalog management (deck: admin edits prices per material).
  Future<void> adminSetPrice(String itemId, double newPrice) async {
    final item = items.firstWhere((i) => i.id == itemId);
    // priceEgp is final on the model for buyers; admin edits go through
    // the backend which owns the catalog, so rebuild the item in place.
    final idx = items.indexOf(item);
    items[idx] = MarketplaceItem(
      id: item.id,
      title: item.title,
      description: item.description,
      category: item.category,
      priceEgp: newPrice,
      unit: item.unit,
      stockKg: item.stockKg,
      sellerName: item.sellerName,
      area: item.area,
      isUpcycled: item.isUpcycled,
    );
    return _delay(null);
  }

  // ---------------------------------------------------------------- Seed ---

  void _seed() {
    users.addAll([
      AppUser(
        id: 'user-amr',
        name: 'Amr Abdelbaqi',
        email: 'amr@greencycle.app',
        role: UserRole.citizen,
        passwordHash: hashPassword('demo123'),
      ),
      AppUser(
        id: 'user-biz',
        name: 'Nile Plastics Co.',
        email: 'buyer@greencycle.app',
        role: UserRole.business,
        passwordHash: hashPassword('demo123'),
      ),
      AppUser(
        id: 'user-emp',
        name: 'Omar Salah',
        email: 'driver@greencycle.app',
        role: UserRole.employee,
        passwordHash: hashPassword('demo123'),
      ),
      AppUser(
        id: 'user-admin',
        name: 'GreenCycle Admin',
        email: 'admin@greencycle.app',
        role: UserRole.admin,
        passwordHash: hashPassword('demo123'),
      ),
    ]);

    SmartBin bin(String id, String name, String area, double dist,
            BinStatus status, double p, double m, double pa, double o) =>
        SmartBin(
          id: id,
          name: name,
          area: area,
          distanceKm: dist,
          qrCode: 'GC-${id.toUpperCase()}',
          status: status,
          fillLevels: {
            WasteCategory.plastic: p,
            WasteCategory.metal: m,
            WasteCategory.paper: pa,
            WasteCategory.other: o,
          },
        );

    bins.addAll([
      bin('bin-01', 'MTI Campus Gate A', 'MTI University, Mokattam', 0.2,
          BinStatus.online, 0.45, 0.30, 0.60, 0.20),
      bin('bin-02', 'MTI Main Library', 'MTI University, Mokattam', 0.4,
          BinStatus.online, 0.70, 0.25, 0.80, 0.15),
      bin('bin-03', 'Nasr City Hub', 'Abbas El Akkad St.', 2.1,
          BinStatus.online, 0.55, 0.50, 0.40, 0.35),
      bin('bin-04', 'Maadi Corniche', 'Maadi, Cairo', 5.6, BinStatus.full,
          0.95, 0.88, 0.92, 0.60),
      bin('bin-05', 'New Cairo Point', '5th Settlement', 8.3,
          BinStatus.maintenance, 0.10, 0.05, 0.20, 0.05),
    ]);

    items.addAll([
      MarketplaceItem(
        id: 'item-01',
        title: 'Shredded PET Plastic',
        description:
            'Clean, pre-sorted PET flakes collected by GreenCycle smart bins. Verified contamination-free.',
        category: WasteCategory.plastic,
        priceEgp: 12,
        unit: 'kg',
        stockKg: 240,
        sellerName: 'GreenCycle Inventory',
        area: 'Mokattam, Cairo',
        isUpcycled: false,
      ),
      MarketplaceItem(
        id: 'item-02',
        title: 'Pressed Aluminum Cans',
        description:
            'Baled aluminum cans, magnet-separated and pressed. Ready for smelters.',
        category: WasteCategory.metal,
        priceEgp: 45,
        unit: 'kg',
        stockKg: 85,
        sellerName: 'GreenCycle Inventory',
        area: 'Mokattam, Cairo',
        isUpcycled: false,
      ),
      MarketplaceItem(
        id: 'item-03',
        title: 'Cardboard Bundles',
        description:
            'Dry corrugated cardboard, sorted at the bin and bundled for pulping mills.',
        category: WasteCategory.paper,
        priceEgp: 6,
        unit: 'kg',
        stockKg: 400,
        sellerName: 'GreenCycle Inventory',
        area: 'Mokattam, Cairo',
        isUpcycled: false,
      ),
      MarketplaceItem(
        id: 'item-04',
        title: 'Upcycled Tote Bag',
        description:
            'Pre-loved tote sewn from reclaimed textile offcuts by a local workshop.',
        category: WasteCategory.other,
        priceEgp: 90,
        unit: 'piece',
        stockKg: 30,
        sellerName: 'ReMade Egypt',
        area: 'Nasr City, Cairo',
        isUpcycled: true,
      ),
      MarketplaceItem(
        id: 'item-05',
        title: 'Bottle Desk Lamp',
        description:
            'Handmade desk lamp built from a recycled glass bottle and low-power LED.',
        category: WasteCategory.other,
        priceEgp: 150,
        unit: 'piece',
        stockKg: 12,
        sellerName: 'ReMade Egypt',
        area: 'Maadi, Cairo',
        isUpcycled: true,
      ),
      MarketplaceItem(
        id: 'item-06',
        title: 'HDPE Pellets',
        description:
            'Washed and pelletized HDPE from bin-sorted containers, industrial grade.',
        category: WasteCategory.plastic,
        priceEgp: 18,
        unit: 'kg',
        stockKg: 120,
        sellerName: 'Nile Plastics Co.',
        area: '10th of Ramadan City',
        isUpcycled: false,
      ),
    ]);

    vouchers.addAll(const [
      Voucher(
        id: 'v-01',
        sponsor: 'Cairo Metro',
        title: 'Metro credit - EGP 25',
        pointsCost: 500,
        valueEgp: 25,
      ),
      Voucher(
        id: 'v-02',
        sponsor: 'FreshMart',
        title: 'Grocery voucher - EGP 50',
        pointsCost: 900,
        valueEgp: 50,
      ),
      Voucher(
        id: 'v-03',
        sponsor: 'Campus Cafe',
        title: 'Free coffee & snack',
        pointsCost: 250,
        valueEgp: 15,
      ),
      Voucher(
        id: 'v-04',
        sponsor: 'RideNow',
        title: 'Ride discount - EGP 75',
        pointsCost: 1400,
        valueEgp: 75,
      ),
    ]);

    tasks.addAll([
      EmployeeTask(
        id: 'task-01',
        kind: TaskKind.binCollection,
        title: 'Empty bin GC-BIN-04 (full)',
        area: 'Maadi Corniche',
        status: TaskStatus.assigned,
        binId: 'bin-04',
      ),
      EmployeeTask(
        id: 'task-02',
        kind: TaskKind.binCollection,
        title: 'Routine collection GC-BIN-02',
        area: 'MTI Main Library',
        status: TaskStatus.enRoute,
        binId: 'bin-02',
      ),
    ]);
  }
}
