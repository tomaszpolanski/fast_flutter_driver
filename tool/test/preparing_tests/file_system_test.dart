import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
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
