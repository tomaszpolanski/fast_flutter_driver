import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/resolution.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'resolution_test.mocks.dart';

@GenerateMocks([Logger, File, Directory])
void main() {
  late MockFile resolutionFile;
  late MockLogger logger;

  MockFile createFile() {
    final MockFile file = MockFile();
    when(file.existsSync()).thenReturn(true);
    when(file.copy(any)).thenAnswer((_) async => MockFile());
    when(file.writeAsString(any)).thenAnswer((_) async => MockFile());
    when(file.delete()).thenAnswer((_) async => MockFile());
    when(file.rename(any)).thenAnswer((_) async => MockFile());
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
            verify(resolutionFile.writeAsString(captureAny)).captured.single,
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
            final file = createFile();
            when(file.existsSync()).thenReturn(true);
            return file;
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
            final file = createFile();
            when(file.existsSync()).thenReturn(false);
            return file;
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
            verify(resolutionFile.writeAsString(captureAny)).captured.single,
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
            final file = createFile();
            when(file.existsSync()).thenReturn(true);
            return file;
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
            verify(resolutionFile.writeAsString(captureAny)).captured.single,
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
            final file = createFile();
            when(file.existsSync()).thenReturn(true);
            return file;
          }
          return resolutionFile;
        },
      );
    });
  });
}
