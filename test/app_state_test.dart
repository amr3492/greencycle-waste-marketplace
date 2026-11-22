import 'package:flutter_test/flutter_test.dart';
import 'package:greencycle/core/app_state.dart';
import 'package:greencycle/core/models.dart';

Future<AppState> signedIn() async {
  final state = AppState();
  await state.login('amr@greencycle.app', 'demo123');
  return state;
}

void main() {
  test('sign-in grants a welcome bonus and loads home data', () async {
    final state = await signedIn();
    expect(state.currentUser, isNotNull);
    expect(state.points, 120);
    expect(state.bins, isNotEmpty);
    expect(state.items, isNotEmpty);
    expect(state.vouchers, isNotEmpty);
  });

  test('deposit credits the wallet instantly', () async {
    final state = await signedIn();
    final before = state.points;
    final record = await state.deposit(
        binId: 'bin-01', category: WasteCategory.metal);
    expect(state.points, before + record.pointsEarned);
    expect(state.records, contains(record));
    expect(state.totalRecycledKg, greaterThan(0));
  });

  test('voucher redemption spends points and issues a code', () async {
    final state = await signedIn();
    for (var i = 0; i < 9; i++) {
      await state.deposit(binId: 'bin-01', category: WasteCategory.metal);
    }
    final voucher = state.vouchers
        .firstWhere((v) => v.pointsCost <= state.points);
    final before = state.points;
    final redemption = await state.redeemVoucher(voucher);
    expect(state.points, before - voucher.pointsCost);
    expect(redemption.code, startsWith('GC-'));
  });

  test('redemption fails without enough points', () async {
    final state = await signedIn();
    final pricey = state.vouchers
        .reduce((a, b) => a.pointsCost > b.pointsCost ? a : b);
    expect(state.points, lessThan(pricey.pointsCost));
    expect(() => state.redeemVoucher(pricey), throwsStateError);
  });

  test('cash out converts points at 100 pts = EGP 10', () async {
    final state = await signedIn();
    state.cashOut(100);
    expect(state.points, 20);
    expect(state.walletEgp, closeTo(10.0, 0.001));
  });

  test('checkout with cash places the order and clears the cart',
      () async {
    final state = await signedIn();
    state.addToCart(state.items.first, 2);
    final order =
        await state.checkout(method: PaymentMethod.cash);
    expect(order.totalEgp, state.items.first.priceEgp * 2);
    expect(state.cart, isEmpty);
    expect(state.myOrders.first.id, order.id);
  });

  test('checkout with a declined card keeps the cart', () async {
    final state = await signedIn();
    state.addToCart(state.items.first, 1);
    expect(
      () => state.checkout(
        method: PaymentMethod.visa,
        cardNumber: '4242424242420000',
        expiry: '12/27',
        cvv: '123',
      ),
      throwsA(anything),
    );
    expect(state.cart, isNotEmpty);
  });

  test('sign out resets the session', () async {
    final state = await signedIn();
    await state.deposit(binId: 'bin-01', category: WasteCategory.paper);
    state.signOut();
    expect(state.currentUser, isNull);
    expect(state.points, 0);
    expect(state.records, isEmpty);
  });
}
