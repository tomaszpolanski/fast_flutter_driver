import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group('validRootDirectory', () {
    test('no pubspec found', () {
      final logger = _MockLogger();

      IOOverrides.runZoned(
        () async {
          final tested = validRootDirectory(logger);
          expect(
            verify(logger.stderr(captureAny)).captured.single,
            'Please run \x1B[1mfastdriver\x1B[0m from the root of your project (directory that contains \x1B[1mpubspec.yaml\x1B[0m)',
          );
          expect(tested, isFalse);
        },
        getCurrentDirectory: () {
          final mockDir = _MockDirectory();
          when(mockDir.listSync(recursive: anyNamed('recursive')))
              .thenReturn([]);
          return mockDir;
        },
      );
    });

    test('pubspec found', () {
      final logger = _MockLogger();

      IOOverrides.runZoned(
        () async {
          final tested = validRootDirectory(logger);

          verifyNever(logger.stderr(any));
          expect(tested, isTrue);
        },
        getCurrentDirectory: () {
          final mockDir = _MockDirectory();
          when(mockDir.listSync(recursive: anyNamed('recursive')))
              .thenReturn([File('pubspec.yaml')]);
          return mockDir;
        },
      );
    });
  });

  group('nativeResolutionFile', () {
    group('for linux', () {
      setUp(() {
        linuxOverride = true;
      });

      tearDown(() {
        linuxOverride = null;
      });

      test('legacy config file', () {
        IOOverrides.runZoned(
          () async {
            final tested = nativeResolutionFile;

            expect(tested, endsWith('main.cc'));
          },
          getCurrentDirectory: () {
            final mockDir = _MockDirectory();
            when(mockDir.path).thenReturn('');
            return mockDir;
          },
          createFile: (name) {
            final file = _MockFile();
            when(file.existsSync()).thenReturn(name == 'linux/main.cc');
            return file;
          },
        );
      });

      test('current config file', () {
        IOOverrides.runZoned(
          () async {
            final tested = nativeResolutionFile;

            expect(tested, endsWith('window_configuration.cc'));
          },
          getCurrentDirectory: () {
            final mockDir = _MockDirectory();
            when(mockDir.path).thenReturn('');
            return mockDir;
          },
          createFile: (name) {
            final file = _MockFile();
            when(file.existsSync()).thenReturn(
              name.endsWith('window_configuration.cc'),
            );
            return file;
          },
        );
      });
    });

    group('for non linux', () {
      setUp(() {
        linuxOverride = false;
      });

      tearDown(() {
        linuxOverride = null;
      });

      test('should not be called', () {
        expect(() => nativeResolutionFile, throwsA(isA<AssertionError>()));
      });
    });
  });
  group('exists', () {
    test('path is null', () {
      final tested = exists(null);

      expect(tested, isFalse);
    });

    test('does not exist', () {
      IOOverrides.runZoned(
        () async {
          final tested = exists('any');

          expect(tested, isFalse);
        },
        createFile: (name) {
          final file = _MockFile();
          when(file.existsSync()).thenReturn(false);
          return file;
        },
      );
    });

    test('does exist', () {
      IOOverrides.runZoned(
        () async {
          final tested = exists('any');

          expect(tested, isTrue);
        },
        createFile: (name) {
          final file = _MockFile();
          when(file.existsSync()).thenReturn(true);
          return file;
        },
      );
    });
  });
}

class _MockDirectory extends Mock implements Directory {}

class _MockFile extends Mock implements File {}

class _MockLogger extends Mock implements Logger {}
