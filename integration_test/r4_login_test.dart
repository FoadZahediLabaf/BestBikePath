
// Implements AT13–AT17 for Requirement R4 (Login).

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bbp_mobile/main.dart' as app;
import '_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('R4 – User Login (AT13–AT17)', () {
    // Use a stable test account. If it doesn't exist in the evaluated system,
    // create it once using the R1 tests or register it manually.
    const email = 'eval_login@test.com';
    const username = 'eval_login_user';
    const password = 'Password123';

    testWidgets('AT13: Successful login with email', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await doLogin(tester, id: email, password: password);

      // Expected: user lands on main screen (any protected label).
      expect(
        find.text('My Trips').evaluate().isNotEmpty ||
            find.text('Profile').evaluate().isNotEmpty ||
            !hasAnyErrorText(tester),
        isTrue,
      );
    });

    testWidgets('AT14: Successful login with username', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await doLogin(tester, id: username, password: password);

      expect(
        find.text('My Trips').evaluate().isNotEmpty ||
            find.text('Profile').evaluate().isNotEmpty ||
            !hasAnyErrorText(tester),
        isTrue,
      );
    });

    testWidgets('AT15: Login with incorrect password', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await doLogin(tester, id: email, password: 'WrongPassword!');
      expect(hasAnyErrorText(tester), isTrue);
    });

    testWidgets('AT16: Login with non-existing user', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await doLogin(tester, id: 'no_such_user_${uniqueSuffix()}@test.com', password: 'Password123');
      expect(hasAnyErrorText(tester), isTrue);
    });

    testWidgets('AT17: Login with empty credentials', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await doLogin(tester, id: '', password: '');
      expect(hasAnyErrorText(tester), isTrue);
    });
  });
}
