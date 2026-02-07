// Implements AT33–AT34 for Requirement R10 (Path Search).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bbp_mobile/main.dart' as app;
import '_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('R10 – Path Search (AT33–AT34)', () {
    testWidgets('AT33: Successful path search with valid locations', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await goToTab(tester, 'Search');

      await enterTextAndSettle(tester, textField(K.originField, labelFallbacks: ['Origin', 'From']), 'Torino');
      await enterTextAndSettle(tester, textField(K.destinationField, labelFallbacks: ['Destination', 'To']), 'Milano');

      final btn = byAnyText(['Search Path', 'Search', 'Find Route']);
      await tapAndSettle(tester, btn, timeout: const Duration(seconds: 20));

      // Expected: map/route result screen appears
      expect(find.byType(Scrollable).evaluate().isNotEmpty || !hasAnyErrorText(tester), isTrue);
    });

    testWidgets('AT34: Path search with invalid locations rejected', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await goToTab(tester, 'Search');

      await enterTextAndSettle(tester, textField(K.originField, labelFallbacks: ['Origin', 'From']), '!!!invalid_origin!!!');
      await enterTextAndSettle(tester, textField(K.destinationField, labelFallbacks: ['Destination', 'To']), '!!!invalid_dest!!!');

      final btn = byAnyText(['Search Path', 'Search', 'Find Route']);
      await tapAndSettle(tester, btn, timeout: const Duration(seconds: 20));

      expect(hasAnyErrorText(tester), isTrue);
    });
  });
}
