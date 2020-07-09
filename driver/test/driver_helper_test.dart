import 'package:fast_flutter_driver/src/driver_helper.dart';
import 'package:fast_flutter_driver_tool/fast_flutter_driver_tool.dart';
import 'package:flutter/foundation.dart';
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
}
