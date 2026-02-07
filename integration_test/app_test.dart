
//
// Single entry point that runs ALL integration tests when executing:
//   flutter test integration_test/app_test.dart
//
// Some CI setups prefer one entry; this imports all test files.

import 'r1_registration_test.dart' as r1;
import 'r4_login_test.dart' as r4;
import 'r6_logout_test.dart' as r6;
import 'r7_profile_test.dart' as r7;
import 'r16_trip_recording_test.dart' as r16;
import 'r20_trip_stats_test.dart' as r20;
import 'r21_trip_history_test.dart' as r21;
import 'r10_path_search_test.dart' as r10;
import 'r11_r12_r13_path_result_test.dart' as r11;
import 'r33_r34_r35_weather_test.dart' as r33;

void main() {
  r1.main();
  r4.main();
  r6.main();
  r7.main();
  r16.main();
  r20.main();
  r21.main();
  r10.main();
  r11.main();
  r33.main();
}
