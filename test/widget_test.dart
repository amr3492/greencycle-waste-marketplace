import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greencycle/app.dart';
import 'package:greencycle/core/app_state.dart';

void main() {
  testWidgets('login flow reaches the four deck pages', (tester) async {
    await tester.pumpWidget(GreenCycleApp(state: AppState()));
    await tester.pumpAndSettle();

    // Login screen with demo credentials prefilled.
    expect(find.text('GreenCycle'), findsOneWidget);
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Home page: points wallet, stats, nearby bins.
    expect(find.byKey(const Key('homePoints')), findsOneWidget);
    expect(find.text('Nearby smart bins'), findsOneWidget);

    // The deck's four pages are the bottom navigation.
    for (final tab in ['Home', 'Recycle', 'Market', 'Profile']) {
      expect(find.text(tab), findsOneWidget);
    }

    // Recycle tab starts the bin picker.
    await tester.tap(find.text('Recycle'));
    await tester.pumpAndSettle();
    expect(find.text('1. Choose a smart bin'), findsOneWidget);

    // Marketplace tab lists seeded inventory.
    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();
    expect(find.text('Shredded PET Plastic'), findsOneWidget);

    // Profile tab shows the user and stats.
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Amr Abdelbaqi'), findsOneWidget);
    expect(find.byKey(const Key('profilePoints')), findsOneWidget);
  });

  testWidgets('employee role sees the route tab', (tester) async {
    final state = AppState();
    await tester.pumpWidget(GreenCycleApp(state: state));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key('emailField')), 'driver@greencycle.app');
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Route'), findsOneWidget);
    await tester.tap(find.text('Route'));
    await tester.pumpAndSettle();
    expect(find.textContaining('GC-BIN'), findsWidgets);
  });
}
