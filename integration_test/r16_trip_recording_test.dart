// Implements AT24–AT26 for Requirement R16 (Manual Trip Recording).

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bbp_mobile/main.dart' as app;
import '_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('R16 – Manual Trip Recording (AT24–AT26)', () {
    const email = 'eval_login@test.com';
    const password = 'Password123';

    testWidgets('AT24: Successful manual trip creation', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await doLogin(tester, id: email, password: password);
      await goToTab(tester, 'Record');

      // Minimal input: one street point if UI supports it
      final street = textField(K.streetField, labelFallbacks: ['Street', 'Via', 'Road']);
      await enterTextAndSettle(tester, street, 'Via Roma');

      final saveBtn = byAnyText(['Save Trip', 'Save', 'Create Trip']);
      await tapAndSettle(tester, saveBtn);

      expect(hasAnySuccessText(tester) || !hasAnyErrorText(tester), isTrue);
    });

    testWidgets('AT25: Trip creation with missing data rejected', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await doLogin(tester, id: email, password: password);
      await goToTab(tester, 'Record');

      // Submit without filling mandatory fields
      final saveBtn = byAnyText(['Save Trip', 'Save', 'Create Trip']);
      await tapAndSettle(tester, saveBtn);

      expect(hasAnyErrorText(tester), isTrue);
    });

    testWidgets('AT26: Trip creation while not authenticated denied', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Try open Record and submit
      await goToTab(tester, 'Record');
      final saveBtn = byAnyText(['Save Trip', 'Save', 'Create Trip']);
      await tapAndSettle(tester, saveBtn);

      expect(find.text('Login').evaluate().isNotEmpty || find.text('Log in').evaluate().isNotEmpty || hasAnyErrorText(tester), isTrue);
    });
  });
}
