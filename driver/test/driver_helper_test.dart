import 'package:fast_flutter_driver/src/driver_helper.dart';
import 'package:fast_flutter_driver_tool/fast_flutter_driver_tool.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group('TestFlutterEx', () {
    <TestPlatform?, TargetPlatform>{
      TestPlatform.android: TargetPlatform.android,
      TestPlatform.iOS: TargetPlatform.iOS,
      null: TargetPlatform.fuchsia,
    }.forEach((key, value) {
      test('when $key', () {
        expect(key?.targetPlatform, value);
      });
    });
  });
  group('configureTest', () {
    BaseConfiguration config;

    setUp(() {
      macOsOverride = false;
      windowsOverride = false;
      linuxOverride = true;
      config = _MockConfiguration();
      when(config.resolution).thenReturn(Resolution.fromSize('1x1'));
    });

    tearDown(() {
      macOsOverride = null;
      windowsOverride = null;
      linuxOverride = null;
    });

    group('platform', () {
      test('when platform is not passed then do not override it', () async {
        const platform = TargetPlatform.android;
        debugDefaultTargetPlatformOverride = platform;
        when(config.platform).thenReturn(null);

        await configureTest(config);

        expect(debugDefaultTargetPlatformOverride, platform);
      });

      test('when platform is passed then do override it', () async {
        const platform = TestPlatform.android;
        debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
        when(config.platform).thenReturn(platform);

        await configureTest(config);

        expect(debugDefaultTargetPlatformOverride, platform.targetPlatform);
      });
    });
  });
}

class _MockConfiguration extends Mock implements BaseConfiguration {}
