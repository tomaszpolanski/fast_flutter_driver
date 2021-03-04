import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/resolution.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks/mock_file.dart';
import 'resolution_test.mocks.dart';

@GenerateMocks([Logger, Directory])
void main() {
  late _MockFile resolutionFile;
  late MockLogger logger;

  _MockFile createFile() {
    final file = _MockFile()
      ..fieldExistsSync = true
      ..copyMock = _MockFile()
      ..writeAsStringMock = _MockFile()
      ..renameMock = _MockFile();
    return file;
  }

  MockDirectory createDir() {
    final dir = MockDirectory();
    when(dir.path).thenReturn('');
    when(dir.rename(any)).thenAnswer((_) async => MockDirectory());
    return dir;
  }

  setUp(() {
    logger = MockLogger();
    when(logger.stderr(any)).thenAnswer((_) {});
    resolutionFile = createFile();
  });

  tearDown(() {
    linuxOverride = null;
  });

  group('current', () {
    setUp(() {
      const content = 'gtk_window_set_default_size(window, 1280, 720);';
      when(resolutionFile.readAsString()).thenAnswer((_) async => content);
    });

    test('replace resolution', () async {
      await IOOverrides.runZoned(
        () async {
          linuxOverride = true;
          await overrideResolution('1x2', () async {}, logger: logger);

          const content = 'gtk_window_set_default_size(window, 1, 2);';
          expect(
            resolutionFile.writeAsStringResult,
            content,
          );
        },
        getCurrentDirectory: () {
          final mockDir = MockDirectory();
          when(mockDir.path).thenReturn('');
          return mockDir;
        },
        createFile: (name) {
          if (name.endsWith('my_application.cc_copy')) {
            return createFile()..fieldExistsSync = true;
          }
          return resolutionFile;
        },
      );
    });

    test('log error copy does not exist', () async {
      await IOOverrides.runZoned(
        () async {
          linuxOverride = true;
          await overrideResolution('1x2', () async {}, logger: logger);

          expect(
            verify(logger.stderr(captureAny)).captured.single,
            'Was not able to restore native as the copy does not exist',
          );
        },
        getCurrentDirectory: () {
          final mockDir = createDir();
          when(mockDir.path).thenReturn('');
          return mockDir;
        },
        createFile: (name) {
          if (name.endsWith('my_application.cc_copy')) {
            return createFile()..fieldExistsSync = false;
          }
          return resolutionFile;
        },
      );
    });
  });

  group('legacy window_configuration.cc', () {
    setUp(() {
      const content = '''
const unsigned int kFlutterWindowWidth = 800;
const unsigned int kFlutterWindowHeight = 600;
''';
      when(resolutionFile.readAsString()).thenAnswer((_) async => content);
    });

    test('replace resolution', () async {
      await IOOverrides.runZoned(
        () async {
          linuxOverride = true;
          await overrideResolution('1x2', () async {}, logger: logger);

          const content = '''
const unsigned int kFlutterWindowWidth = 1;
const unsigned int kFlutterWindowHeight = 2;
''';
          expect(
            resolutionFile.writeAsStringResult,
            content,
          );
        },
        getCurrentDirectory: () {
          final mockDir = createDir();
          when(mockDir.path).thenReturn('');
          return mockDir;
        },
        createFile: (name) {
          if (name.endsWith('my_application.cc_copy')) {
            return createFile()..fieldExistsSync = true;
          }
          return resolutionFile;
        },
      );
    });
  });

  group('legacy linux/main.cc', () {
    setUp(() {
      const content = '''
window_properties.width = 500;
window_properties.height = 900;
''';
      when(resolutionFile.readAsString()).thenAnswer((_) async => content);
    });

    test('replace resolution', () async {
      await IOOverrides.runZoned(
        () async {
          linuxOverride = true;
          await overrideResolution('1x2', () async {}, logger: logger);

          const content = '''
window_properties.width = 1;
window_properties.height = 2;
''';
          expect(
            resolutionFile.writeAsStringResult,
            content,
          );
        },
        getCurrentDirectory: () {
          final mockDir = MockDirectory();
          when(mockDir.path).thenReturn('');
          return mockDir;
        },
        createFile: (name) {
          if (name.endsWith('my_application.cc_copy')) {
            return createFile()..fieldExistsSync = true;
          }
          return resolutionFile;
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

  @override
  Future<FileSystemEntity> delete({bool recursive = false}) async {
    return _MockFile();
  }
}
