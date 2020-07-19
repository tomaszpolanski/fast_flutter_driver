import 'dart:io';

import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mockito_nnbd.dart' as nnbd_mockito;

void main() {
  group('validRootDirectory', () {
    test('no pubspec found', () {
      IOOverrides.runZoned(
        () async {
          expect(isValidRootDirectory, isFalse);
        },
        getCurrentDirectory: () {
          final mockDir = _MockDirectory();
          when(mockDir.listSync(recursive: nnbd_mockito.anyNamed('recursive')))
              .thenReturn([]);
          return mockDir;
        },
      );
    });

    test('pubspec found', () {
      IOOverrides.runZoned(
        () async {
          expect(isValidRootDirectory, isTrue);
        },
        getCurrentDirectory: () {
          final mockDir = _MockDirectory();
          when(mockDir.listSync(recursive: nnbd_mockito.anyNamed('recursive')))
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

      test('legacy linux/main.cc config file', () {
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

      test('legacy window_configuration.cc config file', () {
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

      test('current config file', () {
        IOOverrides.runZoned(
          () async {
            final tested = nativeResolutionFile;

            expect(tested, endsWith('my_application.cc'));
          },
          getCurrentDirectory: () {
            final mockDir = _MockDirectory();
            when(mockDir.path).thenReturn('');
            return mockDir;
          },
          createFile: (name) {
            final file = _MockFile();
            when(file.existsSync()).thenReturn(
              name.endsWith('my_application.cc'),
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
