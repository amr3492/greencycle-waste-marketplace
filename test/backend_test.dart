import 'package:flutter_test/flutter_test.dart';
import 'package:greencycle/core/mock_backend.dart';
import 'package:greencycle/core/models.dart';

void main() {
  group('MockBackend auth', () {
    test('login succeeds with seeded citizen account', () async {
      final backend = MockBackend();
      final user = await backend.login('amr@greencycle.app', 'demo123');
      expect(user.role, UserRole.citizen);
    });

    test('login rejects a wrong password', () {
      final backend = MockBackend();
      expect(() => backend.login('amr@greencycle.app', 'nope'),
          throwsA(isA<AuthException>()));
    });

    test('register rejects duplicate emails', () async {
      final backend = MockBackend();
      expect(
        () => backend.register(
          name: 'Copy',
          email: 'AMR@greencycle.app',
          password: 'secret1',
          role: UserRole.citizen,
        ),
        throwsA(isA<AuthException>()),
      );
    });

    test('register stores hashed passwords, never plain text', () async {
      final backend = MockBackend();
      final user = await backend.register(
        name: 'New User',
        email: 'new@greencycle.app',
        password: 'secret1',
        role: UserRole.business,
      );
      expect(user.passwordHash, isNot(contains('secret1')));
      expect(user.passwordHash, startsWith('fnv1a-'));
    });
  });

  group('Smart bin AI loop', () {
    test('deposit classifies with >=90% confidence and awards points',
        () async {
      final backend = MockBackend();
      final record = await backend.classifyAndDeposit(
          binId: 'bin-01', requested: WasteCategory.plastic);
      expect(record.category, WasteCategory.plastic);
      expect(record.confidence, greaterThanOrEqualTo(0.90));
      expect(record.pointsEarned,
          WasteCategory.plastic.pointsPerItem);
    });

    test('deposit raises the matching compartment fill level', () async {
      final backend = MockBackend();
      final before = backend.bins
          .firstWhere((b) => b.id == 'bin-01')
          .fillLevels[WasteCategory.paper]!;
      await backend.classifyAndDeposit(
          binId: 'bin-01', requested: WasteCategory.paper);
      final after = backend.bins
          .firstWhere((b) => b.id == 'bin-01')
          .fillLevels[WasteCategory.paper]!;
      expect(after, greaterThan(before));
    });

    test('QR lookup is case-insensitive', () {
      final backend = MockBackend();
      expect(backend.findBinByQr('gc-bin-03')?.id, 'bin-03');
      expect(backend.findBinByQr('GC-BIN-99'), isNull);
    });
  });

  group('Payment gateway simulation', () {
    test('valid card returns a success token', () async {
      final backend = MockBackend();
      final result = await backend.authorizeCard(
          cardNumber: '4242424242424242', expiry: '12/27', cvv: '123');
      expect(result.success, isTrue);
      expect(result.token, isNotNull);
    });

    test('card ending in 0000 is declined (try another card)', () async {
      final backend = MockBackend();
      final result = await backend.authorizeCard(
          cardNumber: '4242424242420000', expiry: '12/27', cvv: '123');
      expect(result.success, isFalse);
      expect(result.error, contains('another card'));
    });
  });

  group('Orders and employee flow', () {
    test('placing an order decrements stock and assigns delivery',
        () async {
      final backend = MockBackend();
      final item = backend.items.first;
      final stockBefore = item.stockKg;
      final order = await backend.placeOrder(
        buyerId: 'user-biz',
        lines: [CartLine(item: item, qty: 5)],
        method: PaymentMethod.cash,
      );
      expect(order.totalEgp, item.priceEgp * 5);
      expect(item.stockKg, stockBefore - 5);
      expect(
        backend.tasks.any(
            (t) => t.kind == TaskKind.delivery && t.orderId == order.id),
        isTrue,
      );
    });

    test('completing a delivery task marks the order delivered',
        () async {
      final backend = MockBackend();
      final order = await backend.placeOrder(
        buyerId: 'user-biz',
        lines: [CartLine(item: backend.items[1], qty: 2)],
        method: PaymentMethod.cash,
      );
      final task = backend.tasks.firstWhere(
          (t) => t.kind == TaskKind.delivery && t.orderId == order.id);
      await backend.advanceTask(task.id); // assigned -> enRoute
      await backend.advanceTask(task.id); // enRoute -> done
      expect(order.status, OrderStatus.delivered);
      expect(order.timeline[OrderStatus.delivered], isNotNull);
    });

    test('completing a bin collection empties the bin', () async {
      final backend = MockBackend();
      await backend.advanceTask('task-01'); // assigned -> enRoute
      await backend.advanceTask('task-01'); // enRoute -> done
      final bin = backend.bins.firstWhere((b) => b.id == 'bin-04');
      expect(bin.averageFill, 0);
      expect(bin.status, BinStatus.online);
    });
  });
}
