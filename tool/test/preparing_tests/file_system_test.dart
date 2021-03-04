import 'dart:io';

import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks/mock_file.dart';
import 'file_system_test.mocks.dart';

@GenerateMocks([Directory])
void main() {
  group('validRootDirectory', () {
    test('no pubspec found', () {
      IOOverrides.runZoned(
        () async {
          expect(isValidRootDirectory, isFalse);
        },
        getCurrentDirectory: () {
          final mockDir = MockDirectory();
          when(mockDir.listSync(recursive: anyNamed('recursive')))
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
          final mockDir = MockDirectory();
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

      test('legacy linux/main.cc config file', () {
        IOOverrides.runZoned(
          () async {
            resetMockitoState();
            final tested = nativeResolutionFile;

            expect(tested, endsWith('main.cc'));
          },
          getCurrentDirectory: () {
            final mockDir = MockDirectory();
            when(mockDir.path).thenReturn('');
            return mockDir;
          },
          createFile: (name) {
            return _MockFile()..fieldExistsSync = name == 'linux/main.cc';
          },
        );
      });

      test('legacy window_configuration.cc config file', () {
        final mockDir = MockDirectory();
        when(mockDir.path).thenReturn('');
        IOOverrides.runZoned(
          () async {
            final tested = nativeResolutionFile;

            expect(tested, endsWith('window_configuration.cc'));
          },
          getCurrentDirectory: () {
            return mockDir;
          },
          createFile: (name) {
            return _MockFile()
              ..fieldExistsSync = name.endsWith('window_configuration.cc');
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
            final mockDir = MockDirectory();
            when(mockDir.path).thenReturn('');
            return mockDir;
          },
          createFile: (name) {
            return _MockFile()
              ..fieldExistsSync = name.endsWith('my_application.cc');
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
          return _MockFile()..fieldExistsSync = false;
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
          return _MockFile()..fieldExistsSync = true;
        },
      );
    });
  });
}

class _MockFile extends NonMockitoFile {
  bool fieldExistsSync = false;

  @override
  bool existsSync() {
    return fieldExistsSync;
  }
}
