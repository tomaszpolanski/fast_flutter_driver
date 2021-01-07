import 'package:fast_flutter_driver/src/driver_helper.dart';
import 'package:fast_flutter_driver_tool/fast_flutter_driver_tool.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';

void main() {
  group('TestFlutterEx', () {
    <TestPlatform?, TargetPlatform>{
      TestPlatform.android: TargetPlatform.android,
      TestPlatform.iOS: TargetPlatform.iOS,
    }.forEach((key, value) {
      test('when $key', () {
        expect(key?.targetPlatform, value);
      });
    });
  });
  group('configureTest', () {
    late _MockConfiguration config;

    setUp(() {
      macOsOverride = false;
      windowsOverride = false;
      linuxOverride = true;
      config = _MockConfiguration()..resolution = Resolution.fromSize('1x1');
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
        config.platform = null;

        await configureTest(config);

        expect(debugDefaultTargetPlatformOverride, platform);
      });

      test('when platform is passed then do override it', () async {
        const platform = TestPlatform.android;
        debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
        config.platform = platform;

        await configureTest(config);

        expect(debugDefaultTargetPlatformOverride, platform.targetPlatform);
      });
    });
  });
}

class _MockConfiguration extends BaseConfiguration {
  @override
  TestPlatform? platform;

  @override
  late Resolution resolution;

  @override
  Map<String, dynamic> toJson() => {};
}
