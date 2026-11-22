/// Domain models for the GreenCycle system.
///
/// These mirror the Class Diagram slide of the project deck:
/// User (Citizen / Business / Employee / Admin), SmartBin, QRCode,
/// WasteRecord, Order, Item, Wallet, Payment (Cash / Visa), Voucher.
library;

/// The four AI classification categories from the deck's AI slide.
enum WasteCategory { plastic, metal, paper, other }

extension WasteCategoryX on WasteCategory {
  String get label => switch (this) {
        WasteCategory.plastic => 'Plastic',
        WasteCategory.metal => 'Metal',
        WasteCategory.paper => 'Paper',
        WasteCategory.other => 'Other',
      };

  /// Eco-points awarded per deposited item of this category.
  int get pointsPerItem => switch (this) {
        WasteCategory.plastic => 10,
        WasteCategory.metal => 15,
        WasteCategory.paper => 8,
        WasteCategory.other => 3,
      };

  /// Average weight (kg) used to estimate recycled totals per deposit.
  double get avgWeightKg => switch (this) {
        WasteCategory.plastic => 0.05,
        WasteCategory.metal => 0.12,
        WasteCategory.paper => 0.08,
        WasteCategory.other => 0.10,
      };
}

enum UserRole { citizen, business, employee, admin }

extension UserRoleX on UserRole {
  String get label => switch (this) {
        UserRole.citizen => 'Citizen',
        UserRole.business => 'Business',
        UserRole.employee => 'Employee',
        UserRole.admin => 'Admin',
      };
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.passwordHash,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;

  /// Passwords are never stored in plain text (deck: "hashes passwords").
  final String passwordHash;

  AppUser copyWith({String? name}) => AppUser(
        id: id,
        name: name ?? this.name,
        email: email,
        role: role,
        passwordHash: passwordHash,
      );
}

enum BinStatus { online, full, maintenance }

class SmartBin {
  SmartBin({
    required this.id,
    required this.name,
    required this.area,
    required this.distanceKm,
    required this.qrCode,
    required this.status,
    required this.fillLevels,
  });

  final String id;
  final String name;
  final String area;
  final double distanceKm;

  /// The code printed on the bin's QR sticker, e.g. "GC-BIN-01".
  final String qrCode;
  BinStatus status;

  /// Fill level (0.0 - 1.0) per waste compartment.
  final Map<WasteCategory, double> fillLevels;

  double get averageFill =>
      fillLevels.values.reduce((a, b) => a + b) / fillLevels.length;
}

/// One recognised deposit produced by the smart-bin AI loop
/// (deck: capture -> classify -> sort -> points).
class WasteRecord {
  const WasteRecord({
    required this.id,
    required this.binId,
    required this.category,
    required this.confidence,
    required this.pointsEarned,
    required this.weightKg,
    required this.at,
  });

  final String id;
  final String binId;
  final WasteCategory category;

  /// AI confidence score (0.0 - 1.0).
  final double confidence;
  final int pointsEarned;
  final double weightKg;
  final DateTime at;
}

class MarketplaceItem {
  MarketplaceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priceEgp,
    required this.unit,
    required this.stockKg,
    required this.sellerName,
    required this.area,
    required this.isUpcycled,
  });

  final String id;
  final String title;
  final String description;
  final WasteCategory category;

  /// Price in Egyptian pounds per [unit].
  final double priceEgp;
  final String unit;
  double stockKg;
  final String sellerName;
  final String area;

  /// True for "pre-loved" / upcycled products (deck Marketplace page).
  final bool isUpcycled;
}

class CartLine {
  CartLine({required this.item, required this.qty});

  final MarketplaceItem item;
  double qty;

  double get total => item.priceEgp * qty;
}

enum PaymentMethod { cash, visa }

extension PaymentMethodX on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.cash => 'Cash on Delivery',
        PaymentMethod.visa => 'Visa / Debit Card',
      };
}

enum OrderStatus { pending, preparing, outForDelivery, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
        OrderStatus.pending => 'Pending',
        OrderStatus.preparing => 'Preparing',
        OrderStatus.outForDelivery => 'Out for delivery',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.cancelled => 'Cancelled',
      };

  OrderStatus? get next => switch (this) {
        OrderStatus.pending => OrderStatus.preparing,
        OrderStatus.preparing => OrderStatus.outForDelivery,
        OrderStatus.outForDelivery => OrderStatus.delivered,
        _ => null,
      };
}

class Order {
  Order({
    required this.id,
    required this.buyerId,
    required this.lines,
    required this.totalEgp,
    required this.paymentMethod,
    required this.status,
    required this.placedAt,
    required this.timeline,
  });

  final String id;
  final String buyerId;
  final List<CartLine> lines;
  final double totalEgp;
  final PaymentMethod paymentMethod;
  OrderStatus status;
  final DateTime placedAt;

  /// Status label -> when it was reached, for the tracking timeline.
  final Map<OrderStatus, DateTime> timeline;
}

class Voucher {
  const Voucher({
    required this.id,
    required this.sponsor,
    required this.title,
    required this.pointsCost,
    required this.valueEgp,
  });

  final String id;

  /// Sponsor brand from the deck's business model (retail brand sponsors).
  final String sponsor;
  final String title;
  final int pointsCost;
  final double valueEgp;
}

class Redemption {
  const Redemption({
    required this.voucher,
    required this.code,
    required this.at,
  });

  final Voucher voucher;

  /// The code the user shows at the sponsor's store.
  final String code;
  final DateTime at;
}

enum TxnKind { deposit, purchase, redemption, cashOut, bonus }

class WalletTransaction {
  const WalletTransaction({
    required this.id,
    required this.kind,
    required this.label,
    required this.pointsDelta,
    required this.egpDelta,
    required this.at,
  });

  final String id;
  final TxnKind kind;
  final String label;

  /// Signed change in eco-points.
  final int pointsDelta;

  /// Signed change in wallet cash (EGP).
  final double egpDelta;
  final DateTime at;
}

enum TaskKind { binCollection, delivery }

enum TaskStatus { assigned, enRoute, done }

class EmployeeTask {
  EmployeeTask({
    required this.id,
    required this.kind,
    required this.title,
    required this.area,
    required this.status,
    this.orderId,
    this.binId,
  });

  final String id;
  final TaskKind kind;
  final String title;
  final String area;
  TaskStatus status;
  final String? orderId;
  final String? binId;
}
