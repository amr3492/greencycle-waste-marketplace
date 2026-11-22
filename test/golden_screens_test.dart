import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greencycle/app.dart';
import 'package:greencycle/core/app_state.dart';

void main() {
  testWidgets('golden screens', (tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final state = AppState();
    await tester.pumpWidget(GreenCycleApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();
    await expectLater(
        find.byType(GreenCycleApp), matchesGoldenFile('goldens/home.png'));

    // Recycle tab: bin picker.
    await tester.tap(find.text('Recycle'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await expectLater(
        find.byType(GreenCycleApp), matchesGoldenFile('goldens/recycle_bins.png'));

    // Pick a bin -> waste type grid.
    await tester.tap(find.text('MTI Campus Gate A'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await expectLater(
        find.byType(GreenCycleApp), matchesGoldenFile('goldens/recycle_types.png'));

    // Marketplace.
    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await expectLater(
        find.byType(GreenCycleApp), matchesGoldenFile('goldens/market.png'));

    // Profile.
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await expectLater(
        find.byType(GreenCycleApp), matchesGoldenFile('goldens/profile.png'));
  });
}
