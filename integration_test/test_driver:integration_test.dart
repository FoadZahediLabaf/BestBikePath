// Required for some Flutter versions when running integration tests on devices.
// Run with:
//   flutter test integration_test/app_test.dart
//
// If your Flutter version requires `flutter drive`, use the standard driver setup.

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
