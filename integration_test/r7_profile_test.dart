// Implements AT21–AT23 for Requirement R7 (View User Profile).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bbp_mobile/main.dart' as app;
import '_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('R7 – View User Profile (AT21–AT23)', () {
    const email = 'eval_login@test.com';
    const password = 'Password123';

    testWidgets('AT21: Access user profile', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await doLogin(tester, id: email, password: password);
      await goToTab(tester, 'Profile');

      // Expected: profile info shown (heuristic: email-like text or username label)
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      final hasEmailLike = textWidgets.any((t) => (t.data ?? '').contains('@'));
      expect(hasEmailLike || find.textContaining('Username').evaluate().isNotEmpty, isTrue);
    });

    testWidgets('AT22: Profile data correctness (basic consistency)', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await doLogin(tester, id: email, password: password);
      await goToTab(tester, 'Profile');

      // Expected: email shown somewhere
      expect(find.textContaining('@').evaluate().isNotEmpty, isTrue);
    });

    testWidgets('AT23: Profile access without authentication denied', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Attempt to open Profile without logging in
      await goToTab(tester, 'Profile');

      expect(find.text('Login').evaluate().isNotEmpty || find.text('Log in').evaluate().isNotEmpty || hasAnyErrorText(tester), isTrue);
    });
  });
}
