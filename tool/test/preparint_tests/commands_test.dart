import 'package:fast_flutter_driver_tool/src/preparing_tests/commands.dart';
import 'package:test/test.dart';

void main() {
  group('Flutter', () {
    group('run', () {
      const testFile = 'file.dart';
      test('uses device', () {
        const device = 'some_device';
        final tested = Commands().flutter.run(testFile, device);
        expect(tested, contains('-d $device'));
      });
    });

    group('attach', () {
      const testFile = 'file.dart';
      test('uses device', () {
        const device = 'some_device';
        final tested = Commands().flutter.attach(testFile, device);
        expect(tested, contains('-d $device'));
      });
    });

    group('dart', () {
      const testFile = 'file.dart';
      test('when no parameters', () {
        final tested = Commands().flutter.dart(testFile);

        expect(tested, 'dart $testFile ');
      });

      test('with parameters', () {
        final tested = Commands().flutter.dart(testFile, {
          '-u': 'u',
          '-s': '',
        });

        expect(tested, 'dart $testFile -u u -s');
      });
    });
  });
}
