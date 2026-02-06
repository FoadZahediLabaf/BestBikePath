// Shared helpers for BBP Mobile evaluation tests (AT1–AT40).
// These tests are black-box and try to interact with the UI using either Keys
// (preferred) or visible text labels (fallback). If your target project uses
// different labels/keys, adjust ONLY the selectors below.

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Simple global timeout to keep tests from hanging forever.
const Duration kDefaultPumpTimeout = Duration(seconds: 10);

/// Generates a unique suffix for emails/usernames to avoid collisions.
String uniqueSuffix() => DateTime.now().millisecondsSinceEpoch.toString();

/// Common known keys (adjust if needed).
class K {
  // Auth
  static const Key signupNav = Key('goToSignup');
  static const Key loginNav = Key('goToLogin');
  static const Key nameField = Key('nameField');
  static const Key surnameField = Key('surnameField');
  static const Key usernameField = Key('usernameField');
  static const Key emailField = Key('emailField');
  static const Key passwordField = Key('passwordField');
  static const Key loginIdField = Key('loginField'); // email or username
  static const Key registerButton = Key('registerButton');
  static const Key loginButton = Key('loginButton');
  static const Key logoutButton = Key('logoutButton');

  // Navigation
  static const Key profileTab = Key('profileTab');
  static const Key myTripsTab = Key('myTripsTab');
  static const Key recordTab = Key('recordTab');
  static const Key searchTab = Key('searchTab');

  // Trip
  static const Key streetField = Key('streetField');
  static const Key saveTripButton = Key('saveTripButton');

  // Path search
  static const Key originField = Key('originField');
  static const Key destinationField = Key('destinationField');
  static const Key searchPathButton = Key('searchPathButton');
}

/// Tap a widget (Finder) and settle.
Future<void> tapAndSettle(WidgetTester tester, Finder f,
    {Duration timeout = kDefaultPumpTimeout}) async {
  expect(f, findsOneWidget);
  await tester.tap(f);
  await tester.pumpAndSettle(timeout);
}

/// Enter text into a field (Finder) and settle.
Future<void> enterTextAndSettle(WidgetTester tester, Finder f, String value,
    {Duration timeout = kDefaultPumpTimeout}) async {
  expect(f, findsOneWidget);
  await tester.enterText(f, value);
  await tester.pumpAndSettle(timeout);
}

/// Attempts to find a widget by Key, else by text label.
/// This makes the test suite more portable for evaluation.
Finder byKeyOrText(Key key, String text) {
  return find.byKey(key).evaluate().isNotEmpty ? find.byKey(key) : find.text(text);
}

/// Tries multiple text labels; returns the first that exists.
Finder byAnyText(List<String> labels) {
  for (final l in labels) {
    final f = find.text(l);
    if (f.evaluate().isNotEmpty) return f;
  }
  // If none found, return a Finder that will fail with a clear message.
  return find.text(labels.first);
}

/// Robust: find a TextField (or TextFormField) by Key.
/// If not found, falls back to searching by label/hint text.
Finder textField(Key key, {List<String>? labelFallbacks}) {
  final byKey = find.byKey(key);
  if (byKey.evaluate().isNotEmpty) return byKey;
  if (labelFallbacks != null) {
    for (final lbl in labelFallbacks) {
      final f = find.widgetWithText(TextFormField, lbl);
      if (f.evaluate().isNotEmpty) return f;
      final f2 = find.widgetWithText(TextField, lbl);
      if (f2.evaluate().isNotEmpty) return f2;
    }
  }
  return byKey; // will fail later with a meaningful expect
}

/// Best-effort: checks if any visible error text exists (generic).
bool hasAnyErrorText(WidgetTester tester) {
  final patterns = [
    'error',
    'invalid',
    'required',
    'already',
    'exists',
    'failed',
    'wrong',
    'missing',
  ];
  final allTexts = tester.widgetList<Text>(find.byType(Text)).map((t) => t.data ?? '');
  return allTexts.any((s) => patterns.any((p) => s.toLowerCase().contains(p)));
}

/// Best-effort: checks if some success/redirect indicator is present.
bool hasAnySuccessText(WidgetTester tester) {
  final patterns = [
    'success',
    'created',
    'registered',
    'welcome',
    'saved',
    'logged in',
  ];
  final allTexts = tester.widgetList<Text>(find.byType(Text)).map((t) => t.data ?? '');
  return allTexts.any((s) => patterns.any((p) => s.toLowerCase().contains(p)));
}

/// Navigates to Sign Up screen using common labels.
Future<void> goToSignup(WidgetTester tester) async {
  final f = byAnyText(['Sign Up', 'Signup', 'Register', 'Create account']);
  await tapAndSettle(tester, f);
}

/// Navigates to Login screen using common labels.
Future<void> goToLogin(WidgetTester tester) async {
  final f = byAnyText(['Login', 'Log in', 'Sign in']);
  await tapAndSettle(tester, f);
}

/// Performs registration with provided values.
Future<void> doRegister(
  WidgetTester tester, {
  required String name,
  required String surname,
  required String username,
  required String email,
  required String password,
}) async {
  await enterTextAndSettle(tester, textField(K.nameField, labelFallbacks: ['Name']), name);
  await enterTextAndSettle(
      tester, textField(K.surnameField, labelFallbacks: ['Surname', 'Last name']), surname);
  await enterTextAndSettle(
      tester, textField(K.usernameField, labelFallbacks: ['Username']), username);
  await enterTextAndSettle(tester, textField(K.emailField, labelFallbacks: ['Email']), email);
  await enterTextAndSettle(
      tester, textField(K.passwordField, labelFallbacks: ['Password']), password);

  final btn = byAnyText(['Register', 'Sign Up', 'Create', 'Create account']);
  await tapAndSettle(tester, btn);
}

/// Performs login with identifier (email or username) and password.
Future<void> doLogin(
  WidgetTester tester, {
  required String id,
  required String password,
}) async {
  await enterTextAndSettle(
      tester, textField(K.loginIdField, labelFallbacks: ['Email', 'Username', 'Email or username']), id);
  await enterTextAndSettle(tester, textField(K.passwordField, labelFallbacks: ['Password']), password);

  final btn = byAnyText(['Login', 'Log in', 'Sign in']);
  await tapAndSettle(tester, btn);
}

/// Attempts to log out using common icon/text.
Future<void> doLogout(WidgetTester tester) async {
  // Prefer text button
  final txt = byAnyText(['Logout', 'Log out', 'Sign out']);
  if (txt.evaluate().isNotEmpty) {
    await tapAndSettle(tester, txt);
    return;
  }
  // Fallback to icon
  final icon = find.byIcon(Icons.logout);
  if (icon.evaluate().isNotEmpty) {
    await tapAndSettle(tester, icon);
    return;
  }
  // Last resort: key
  final key = find.byKey(K.logoutButton);
  await tapAndSettle(tester, key);
}

/// Navigate using bottom/tab labels if available.
Future<void> goToTab(WidgetTester tester, String tabLabel) async {
  final f = find.text(tabLabel);
  if (f.evaluate().isNotEmpty) {
    await tapAndSettle(tester, f);
  }
}
