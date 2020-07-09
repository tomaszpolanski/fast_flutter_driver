import 'package:fast_flutter_driver/src/driver_helper.dart';
import 'package:fast_flutter_driver_tool/fast_flutter_driver_tool.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group('TestFlutterEx', () {
    <TestPlatform, TargetPlatform>{
      TestPlatform.android: TargetPlatform.android,
      TestPlatform.iOS: TargetPlatform.iOS,
      null: TargetPlatform.fuchsia,
    }.forEach((key, value) {
      test('when $key', () {
        expect(key.targetPlatform, value);
      });
    });
  });
  group('configureTest', () {
    tearDown(() {
      macOsOverride = null;
      windowsOverride = null;
    });

    test('init', () async {
      macOsOverride = false;
      windowsOverride = false;
      final config = _MockConfiguration();
      when(config.resolution).thenReturn(Resolution.fromSize('1x1'));

      final tested = await configureTest(config);

      expect(tested, isNull);
    });
  });
}

class _MockConfiguration extends Mock implements BaseConfiguration {}
