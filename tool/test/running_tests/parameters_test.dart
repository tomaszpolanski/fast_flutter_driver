import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:test/test.dart';

void main() {
  group('testParameters', () {
    [
      url,
      resolutionArg,
      platformArg,
      languageArg,
      screenshotsArg,
      // ignore: avoid_function_literals_in_foreach_calls
    ].forEach((option) {
      test(option, () {
        expect(testParameters.options.containsKey(option), isTrue);
      });
    });
  });

  group('TestPlatform', () {
    group('fromString', () {
      <String, TestPlatform>{
        'android': TestPlatform.android,
        'Android': TestPlatform.android,
        'ios': TestPlatform.iOS,
        'iOs': TestPlatform.iOS,
        'invalid': null,
      }.forEach((key, value) {
        test(key, () {
          expect(TestPlatformEx.fromString(key), value);
        });
      });
    });

    group('asString', () {
      <TestPlatform, String>{
        TestPlatform.android: 'android',
        TestPlatform.iOS: 'iOS',
      }.forEach((key, value) {
        test(key, () {
          expect(key.asString(), value);
        });
      });
    });
  });
}
