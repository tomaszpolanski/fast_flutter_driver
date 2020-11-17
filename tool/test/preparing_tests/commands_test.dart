import 'package:fast_flutter_driver_tool/src/preparing_tests/commands.dart';
import 'package:test/test.dart';

void main() {
  group('Flutter', () {
    group('run', () {
      const testFile = 'file.dart';
      test('uses device', () {
        const device = 'some_device';
        final tested = Commands().flutter.run(testFile, device, flavor: null);
        expect(tested, contains('-d $device'));
      });

      test('passes flavor if available', () {
        const flavor = 'chocolate';
        final tested =
            Commands().flutter.run(testFile, 'some_device', flavor: flavor);
        expect(tested, contains('--flavor $flavor'));
      });

      test('passes additional arguments if available', () {
        const arguments = '--device-user=10 --host-vmservice-port';
        final tested = Commands().flutter.run(
              testFile,
              'some_device',
              flavor: null,
              additionalArguments: arguments,
            );
        expect(tested, contains(arguments));
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

        expect(tested, 'dart $testFile');
      });

      test('with parameters', () {
        final tested = Commands().flutter.dart(testFile, testArguments: {
          '-u': 'u',
          '-s': '',
        });

        expect(tested, 'dart $testFile -u u -s');
      });

      test('with dart parameters', () {
        const dartArgs = '--enable-experiment=non-nullable';

        final tested = Commands().flutter.dart(
              testFile,
              dartArguments: dartArgs,
            );

        expect(tested, 'dart $dartArgs $testFile');
      });
    });
  });
}
