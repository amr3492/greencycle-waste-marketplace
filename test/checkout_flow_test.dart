import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greencycle/app.dart';
import 'package:greencycle/core/app_state.dart';

void main() {
  testWidgets('full recycle deposit flow credits eco-points', (tester) async {
    await tester.pumpWidget(GreenCycleApp(state: AppState()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();

    final before = tester
        .widget<Text>(find.byKey(const Key('homePoints')))
        .data!;
    expect(before, '120 pts');

    // Recycle tab -> pick bin -> pick Plastic -> simulate scan -> timers.
    await tester.tap(find.text('Recycle'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('MTI Campus Gate A'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plastic'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('simulateScanButton')), findsOneWidget);
    await tester.tap(find.byKey(const Key('simulateScanButton')));
    // scan sim (1.4s + 0.9s) + classify (1.5s + 1.5s) + deposit (0.35s)
    // + servo countdown (3s). Staged pumps: pumpAndSettle stops at the
    // first idle frame and would not advance through the timer chain.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('depositResult')), findsOneWidget);
    expect(find.text('+10 eco-points'), findsOneWidget);
  });

  testWidgets('marketplace checkout with cash places a tracked order',
      (tester) async {
    await tester.pumpWidget(GreenCycleApp(state: AppState()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shredded PET Plastic'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('addToCartButton')));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('cartButton')));
    await tester.pumpAndSettle();
    expect(find.text('EGP 12.00'), findsOneWidget);
    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('payButton')));
    await tester.pumpAndSettle();
    expect(find.text('Order placed!'), findsOneWidget);
    await tester.tap(find.byKey(const Key('trackOrderButton')));
    await tester.pumpAndSettle();
    expect(find.textContaining('ORD-'), findsOneWidget);
  });

  testWidgets('visa decline shows the deck\'s try-another-card error',
      (tester) async {
    await tester.pumpWidget(GreenCycleApp(state: AppState()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cardboard Bundles'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('addToCartButton')));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('cartButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Visa'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key('cardNumberField')), '4242424242420000');
    await tester.enterText(find.widgetWithText(TextField, 'Expiry (MM/YY)'),
        '12/27');
    await tester.enterText(
        find.widgetWithText(TextField, 'CVV'), '123');
    await tester.tap(find.byKey(const Key('payButton')));
    await tester.pumpAndSettle();
    expect(
        find.textContaining('try another card',
            findRichText: true),
        findsOneWidget);
  });
}
