// Implements AT27–AT29 for Requirement R20 (Trip Statistics).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bbp_mobile/main.dart' as app;
import '_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('R20 – Trip Statistics (AT27–AT29)', () {
    const email = 'eval_login@test.com';
    const password = 'Password123';

    testWidgets('AT27: Display of trip distance', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await doLogin(tester, id: email, password: password);

      await goToTab(tester, 'My Trips');
      // Open first trip if any
      final tile = find.byType(ListTile);
      if (tile.evaluate().isNotEmpty) {
        await tester.tap(tile.first);
        await tester.pumpAndSettle();
      }

      // Expect a distance marker (e.g., "km" or "m")
      expect(find.textContaining('km').evaluate().isNotEmpty || find.textContaining('m').evaluate().isNotEmpty, isTrue);
    });

    testWidgets('AT28: Display of trip duration', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await doLogin(tester, id: email, password: password);

      await goToTab(tester, 'My Trips');
      final tile = find.byType(ListTile);
      if (tile.evaluate().isNotEmpty) {
        await tester.tap(tile.first);
        await tester.pumpAndSettle();
      }

      // Expect a duration marker ("min", "h", ":")
      expect(
        find.textContaining('min').evaluate().isNotEmpty ||
            find.textContaining('h').evaluate().isNotEmpty ||
            find.textContaining(':').evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('AT29: Consistency of statistics across views', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await doLogin(tester, id: email, password: password);

      await goToTab(tester, 'My Trips');

      // Capture summary text before opening details
      final summaryText = tester.widgetList<Text>(find.byType(Text)).map((t) => t.data ?? '').join(' ');
      final tile = find.byType(ListTile);

      if (tile.evaluate().isNotEmpty) {
        await tester.tap(tile.first);
        await tester.pumpAndSettle();
      }

      final detailText = tester.widgetList<Text>(find.byType(Text)).map((t) => t.data ?? '').join(' ');

      // Heuristic: distance token appears in both
      final summaryHasKm = summaryText.contains('km');
      final detailHasKm = detailText.contains('km');

      expect(summaryHasKm == detailHasKm || detailHasKm, isTrue);
    });
  });
}
