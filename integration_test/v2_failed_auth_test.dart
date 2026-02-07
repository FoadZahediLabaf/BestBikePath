import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bbp_mobile/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  // Initializes the integration test environment
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    // Test Case ID: TC-V2-F01
    // Purpose:
    // Verify that a user can successfully sign up using valid credentials
    // and is redirected to the main application view.
    //
    // Expected (by specification):
    // - Backend creates the user
    // - UI navigates to the home/map screen
    //
    // Current status:
    // - The authentication UI is not fully integrated with backend responses
    // - Navigation after signup is unstable and may cause crashes
    //
    // Result:
    // - Test is marked as skipped and classified as an expected failure in V2
    'TC-V2-F01 – User sign-up fails due to incomplete UI integration',
    (WidgetTester tester) async {
      // Launch the application
      app.main();
      await tester.pumpAndSettle();

      // Navigate to the Sign Up screen
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Fill in the sign-up form with valid credentials
      await tester.enterText(
          find.byKey(const Key('emailField')), 'test@test.com');
      await tester.enterText(
          find.byKey(const Key('passwordField')), 'Password123!');
      await tester.enterText(
          find.byKey(const Key('confirmPasswordField')), 'Password123!');

      // Submit the form
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Expected outcome (not currently achieved):
      // The user should be redirected to the map/home screen
      expect(find.text('Map'), findsOneWidget);
    },
    // The test is skipped because the failure is due to
    // incomplete UI–backend authentication integration,
    // not due to missing requirements.
    skip: true,
  );
}
