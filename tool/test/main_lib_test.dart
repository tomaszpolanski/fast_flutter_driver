import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/update/path_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../bin/main.dart' as main_file;

void main() {
  group('commands', () {
    test('help', () async {
      final logger = _MockLogger();

      await main_file.run(
        ['-h'],
        loggerFactory: (_) => logger,
        pathProvider: PathProvider(),
        httpGet: (_) => null,
      );

      expect(
        verify(logger.stdout(captureAny)).captured.single,
        startsWith('Usage: fastdriver <path>'),
      );
    });

    test('version', () async {
      const version = '1.0.0+1';
      final pathProvider = _MockPathProvider();
      when(pathProvider.scriptDir).thenReturn('/root/');
      final logger = _MockLogger();

      await IOOverrides.runZoned(
        () async {
          await main_file.run(
            ['--version'],
            loggerFactory: (_) => logger,
            pathProvider: pathProvider,
            httpGet: (_) => null,
          );

          expect(verify(logger.stdout(captureAny)).captured.single, version);
        },
        createFile: (name) {
          final File file = _MockFile();
          when(file.existsSync()).thenReturn(true);
          when(file.readAsString())
              .thenAnswer((_) async => 'version: $version');
          return file;
        },
      );
    });
  });

  group('current project directory', () {
    test('when invalid', () async {
      await IOOverrides.runZoned(
        () async {
          final logger = _MockLogger();

          await main_file.run(
            [''],
            loggerFactory: (_) => logger,
            pathProvider: PathProvider(),
            httpGet: (_) => null,
          );
          expect(
            verify(logger.stderr(captureAny)).captured.single,
            'Please run \x1B[1mfastdriver\x1B[0m from the root of your project (directory that contains \x1B[1mpubspec.yaml\x1B[0m)',
          );
        },
        getCurrentDirectory: () {
          final mockDir = _MockDirectory();
          when(mockDir.listSync(recursive: anyNamed('recursive')))
              .thenReturn([]);
          return mockDir;
        },
      );
    });
  });

  test('deletes screenshots if the folder exists and passing the flag', () {
    Directory directory;

    IOOverrides.runZoned(
      () async {
        await main_file.run(
          ['-s'],
          loggerFactory: (_) => _MockLogger(),
          pathProvider: PathProvider(),
          httpGet: (_) => null,
        );

        verify(directory.deleteSync(recursive: true)).called(1);
      },
      createDirectory: (name) {
        final mockDir = _MockDirectory();
        if (name == screenshotsArg) {
          directory = mockDir;
        }

        when(mockDir.path).thenReturn(name);
        when(mockDir.existsSync()).thenReturn(true);
        when(mockDir.listSync(recursive: anyNamed('recursive'))).thenReturn([]);

        return mockDir;
      },
      getCurrentDirectory: () {
        final mockDir = _MockDirectory();
        when(mockDir.listSync(recursive: anyNamed('recursive')))
            .thenReturn([File('pubspec.yaml')]);
        return mockDir;
      },
    );
  });
}

class _MockDirectory extends Mock implements Directory {}

class _MockLogger extends Mock implements Logger {}

class _MockFile extends Mock implements File {}

class _MockPathProvider extends Mock implements PathProvider {}
