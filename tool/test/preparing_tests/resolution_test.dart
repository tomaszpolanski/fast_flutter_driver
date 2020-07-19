import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/resolution.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mockito_nnbd.dart' as nnbd_mockito;

void main() {
  late File resolutionFile;
  late Logger logger;

  setUp(() {
    logger = _MockLogger();
    resolutionFile = _MockFile();
    when(resolutionFile.existsSync()).thenReturn(true);
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
            verify(resolutionFile.writeAsString(nnbd_mockito.captureAny))
                .captured
                .single,
            content,
          );
        },
        getCurrentDirectory: () {
          final mockDir = _MockDirectory();
          when(mockDir.path).thenReturn('');
          return mockDir;
        },
        createFile: (name) {
          if (name.endsWith('my_application.cc_copy')) {
            final file = _MockFile();
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
          final mockDir = _MockDirectory();
          when(mockDir.path).thenReturn('');
          return mockDir;
        },
        createFile: (name) {
          if (name.endsWith('my_application.cc_copy')) {
            final file = _MockFile();
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
          final mockDir = _MockDirectory();
          when(mockDir.path).thenReturn('');
          return mockDir;
        },
        createFile: (name) {
          if (name.endsWith('my_application.cc_copy')) {
            final file = _MockFile();
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
            verify(resolutionFile.writeAsString(nnbd_mockito.captureAny))
                .captured
                .single,
            content,
          );
        },
        getCurrentDirectory: () {
          final mockDir = _MockDirectory();
          when(mockDir.path).thenReturn('');
          return mockDir;
        },
        createFile: (name) {
          if (name.endsWith('my_application.cc_copy')) {
            final file = _MockFile();
            when(file.existsSync()).thenReturn(true);
            return file;
          }
          return resolutionFile;
        },
      );
    });
  });
}

class _MockDirectory extends Mock implements Directory {}

class _MockFile extends Mock implements File {}

class _MockLogger extends Mock implements Logger {}
