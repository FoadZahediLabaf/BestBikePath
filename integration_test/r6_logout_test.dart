
// Implements AT18–AT20 for Requirement R6 (Logout).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bbp_mobile/main.dart' as app;
import '_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('R6 – Logout (AT18–AT20)', () {
    const email = 'eval_login@test.com';
    const password = 'Password123';

    testWidgets('AT18: Successful logout', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await doLogin(tester, id: email, password: password);
      await doLogout(tester);

      // Expected: back to login UI
      expect(find.text('Login').evaluate().isNotEmpty || find.text('Log in').evaluate().isNotEmpty, isTrue);
    });

    testWidgets('AT19: Access protected screen after logout denied', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await doLogin(tester, id: email, password: password);
      await doLogout(tester);

      // Try to open a protected area (My Trips / Profile). Should redirect to login or fail gracefully.
      await goToTab(tester, 'My Trips');
      expect(find.text('Login').evaluate().isNotEmpty || find.text('Log in').evaluate().isNotEmpty || hasAnyErrorText(tester), isTrue);
    });

    testWidgets('AT20: Logout persists after app restart', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await doLogin(tester, id: email, password: password);
      await doLogout(tester);

      // Simulate restart by calling main again
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Login').evaluate().isNotEmpty || find.text('Log in').evaluate().isNotEmpty, isTrue);
    });
  });
}
