import 'package:fast_flutter_driver_tool/src/running_tests/test_properties.dart';
import 'package:test/test.dart';

void main() {
  group('TestProperties', () {
    test('additionalArgs', () {
      const arguments = 'special-arguments-that-will-be-passed-to-the-test';
      final tested = TestProperties(['--test-args', arguments]).additionalArgs;

      expect(tested, arguments);
    });
  });
}
