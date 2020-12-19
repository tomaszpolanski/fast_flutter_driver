import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/test_generator/test_generator.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/testing.dart'
    as test_executor;
import 'package:fast_flutter_driver_tool/src/preparing_tests/testing.dart'
    hide setUp;
import 'package:fast_flutter_driver_tool/src/update/version.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../bin/main.dart' as main_file;
import 'main_lib_test.mocks.dart';
import 'mockito_nnbd.dart' as nnbd_mockito;

@GenerateMocks([
  Logger,
  VersionChecker,
  test_executor.TestExecutor,
  TestFileProvider,
  Directory
])
void main() {
  late VersionChecker versionChecker;
  late Logger logger;
  late test_executor.TestExecutor testExecutor;
  late TestFileProvider testFileProvider;

  setUp(() {
    versionChecker = MockVersionChecker();
    logger = MockLogger();
    testExecutor = MockTestExecutor();
    testFileProvider = MockTestFileProvider();
  });
  group('commands', () {
    tearDown(() {
      linuxOverride = null;
    });

    test('help', () async {
      await main_file.run(
        ['-h'],
        loggerFactory: (_) => logger,
        versionCheckerFactory: (_) => versionChecker,
        testExecutorFactory: (_) => testExecutor,
        testFileProviderFactory: (_) => testFileProvider,
      );

      expect(
        verify(logger.stdout(nnbd_mockito.captureAny)).captured.single,
        startsWith('Usage: fastdriver <path>'),
      );
    });

    test('version', () async {
      const version = '1.0.0+1';
      when(versionChecker.currentVersion()).thenAnswer((_) async => version);

      await main_file.run(
        ['--version'],
        loggerFactory: (_) => logger,
        versionCheckerFactory: (_) => versionChecker,
        testExecutorFactory: (_) => testExecutor,
        testFileProviderFactory: (_) => testFileProvider,
      );

      expect(verify(logger.stdout(nnbd_mockito.captureAny)).captured.single,
          version);
    });

    test('flavor', () async {
      linuxOverride = false;
      when(versionChecker.checkForUpdates()).thenAnswer((_) async => null);
      when(testFileProvider.testFile(nnbd_mockito.any))
          .thenAnswer((_) async => 'any');
      const flavor = 'chocolate';
      await IOOverrides.runZoned(
        () async {
          await main_file.run(
            ['--flavor', flavor],
            loggerFactory: (_) => logger,
            versionCheckerFactory: (_) => versionChecker,
            testExecutorFactory: (_) => testExecutor,
            testFileProviderFactory: (_) => testFileProvider,
          );
        },
        getCurrentDirectory: () {
          final mockDir = MockDirectory();
          when(mockDir.listSync(recursive: nnbd_mockito.anyNamed('recursive')))
              .thenReturn([File('pubspec.yaml')]);
          return mockDir;
        },
      );

      final ExecutorParameters parameters = verify(
        testExecutor.test(
          nnbd_mockito.any,
          parameters: nnbd_mockito.captureAnyNamed('parameters'),
        ),
      ).captured.single;
      expect(parameters.flavor, flavor);
    });

    test('flutter arguments', () async {
      const arguments = '--device-user=10 --host-vmservice-port';
      linuxOverride = false;
      when(versionChecker.checkForUpdates()).thenAnswer((_) async => null);
      when(testFileProvider.testFile(nnbd_mockito.any))
          .thenAnswer((_) async => 'any');

      await main_file.run(
        ['--flutter-args', arguments],
        loggerFactory: (_) => logger,
        versionCheckerFactory: (_) => versionChecker,
        testExecutorFactory: (_) => testExecutor,
        testFileProviderFactory: (_) => testFileProvider,
      );

      final ExecutorParameters parameters = verify(
        testExecutor.test(nnbd_mockito.any,
            parameters: nnbd_mockito.captureAnyNamed('parameters')),
      ).captured.single;
      expect(parameters.flutterArguments, arguments);
    });

    test('dart arguments', () async {
      const arguments = '--enable-experiment=non-nullable';
      linuxOverride = false;
      when(versionChecker.checkForUpdates()).thenAnswer((_) async => null);
      when(testFileProvider.testFile(nnbd_mockito.any))
          .thenAnswer((_) async => 'any');

      await main_file.run(
        ['--dart-args', arguments],
        loggerFactory: (_) => logger,
        versionCheckerFactory: (_) => versionChecker,
        testExecutorFactory: (_) => testExecutor,
        testFileProviderFactory: (_) => testFileProvider,
      );

      final ExecutorParameters parameters = verify(
        testExecutor.test(nnbd_mockito.any,
            parameters: nnbd_mockito.captureAnyNamed('parameters')),
      ).captured.single;
      expect(parameters.dartArguments, arguments);
    });

    test('additional test arguments', () async {
      const arguments = 'special-arguments-that-will-be-passed-to-the-test';
      linuxOverride = false;
      when(versionChecker.checkForUpdates()).thenAnswer((_) async => null);
      when(testFileProvider.testFile(nnbd_mockito.any))
          .thenAnswer((_) async => 'any');

      await main_file.run(
        ['--test-args', arguments],
        loggerFactory: (_) => logger,
        versionCheckerFactory: (_) => versionChecker,
        testExecutorFactory: (_) => testExecutor,
        testFileProviderFactory: (_) => testFileProvider,
      );

      final ExecutorParameters parameters = verify(
        testExecutor.test(nnbd_mockito.any,
            parameters: nnbd_mockito.captureAnyNamed('parameters')),
      ).captured.single;
      expect(parameters.testArguments, arguments);
    });

    test('invalid command displays help', () async {
      const unknownCommand = 'this-is-unknown-command';
      await main_file.run(
        ['--$unknownCommand'],
        loggerFactory: (_) => logger,
        versionCheckerFactory: (_) => versionChecker,
        testExecutorFactory: (_) => testExecutor,
        testFileProviderFactory: (_) => testFileProvider,
      );

      expect(
        verify(logger.stderr(nnbd_mockito.captureAny)).captured.single,
        '''
Could not find an option named "$unknownCommand".
Try '\x1B[92mfastdriver --help\x1B[0m' for more information.''',
      );
    });
  });

  group('current project directory', () {
    test('when invalid', () async {
      await IOOverrides.runZoned(
        () async {
          await main_file.run(
            [''],
            loggerFactory: (_) => logger,
            versionCheckerFactory: (_) => versionChecker,
            testExecutorFactory: (_) => testExecutor,
            testFileProviderFactory: (_) => testFileProvider,
          );
          expect(
            verify(logger.stderr(nnbd_mockito.captureAny)).captured.single,
            'Please run \x1B[1mfastdriver\x1B[0m from the root of your project (directory that contains \x1B[1mpubspec.yaml\x1B[0m)',
          );
        },
        getCurrentDirectory: () {
          final mockDir = MockDirectory();
          when(mockDir.listSync(recursive: nnbd_mockito.anyNamed('recursive')))
              .thenReturn([]);
          return mockDir;
        },
      );
    });
  });

  group('update', () {
    test('available', () async {
      const local = '1.0.0+1';
      const remote = '2.0.0+1';
      when(versionChecker.checkForUpdates()).thenAnswer(
        (_) async => const AppVersion(local: local, remote: remote),
      );

      await IOOverrides.runZoned(
        () async {
          await main_file.run(
            [''],
            loggerFactory: (_) => logger,
            versionCheckerFactory: (_) => versionChecker,
            testExecutorFactory: (_) => testExecutor,
            testFileProviderFactory: (_) => testFileProvider,
          );
        },
        getCurrentDirectory: () {
          final mockDir = MockDirectory();
          when(mockDir.listSync(recursive: nnbd_mockito.anyNamed('recursive')))
              .thenReturn([File('pubspec.yaml')]);
          return mockDir;
        },
      );

      final messages = verify(logger.stdout(nnbd_mockito.captureAny)).captured;
      expect(
        messages[1],
        '\x1B[92mNew version\x1B[0m (\x1B[1m$remote\x1B[0m) available!',
      );
      expect(
        messages[2],
        "To update, run \x1B[92m'pub global activate fast_flutter_driver_tool'\x1B[0m",
      );
    });

    test('up to date', () async {
      const local = '2.0.0+1';
      const remote = '2.0.0+1';
      when(versionChecker.checkForUpdates()).thenAnswer(
        (_) async => const AppVersion(local: local, remote: remote),
      );

      await IOOverrides.runZoned(
        () async {
          await main_file.run(
            [''],
            loggerFactory: (_) => logger,
            versionCheckerFactory: (_) => versionChecker,
            testExecutorFactory: (_) => testExecutor,
            testFileProviderFactory: (_) => testFileProvider,
          );
        },
        getCurrentDirectory: () {
          final mockDir = MockDirectory();
          when(mockDir.listSync(recursive: nnbd_mockito.anyNamed('recursive')))
              .thenReturn([File('pubspec.yaml')]);
          return mockDir;
        },
      );

      final messages = verify(logger.stdout(nnbd_mockito.captureAny)).captured;
      expect(messages[0], 'Starting tests');
    });
  });

  test('deletes screenshots if the folder exists and passing the flag', () {
    late Directory directory;

    when(versionChecker.checkForUpdates()).thenAnswer((_) async => null);
    IOOverrides.runZoned(
      () async {
        await main_file.run(
          ['-s'],
          loggerFactory: (_) => logger,
          versionCheckerFactory: (_) => versionChecker,
          testExecutorFactory: (_) => testExecutor,
          testFileProviderFactory: (_) => testFileProvider,
        );

        verify(directory.deleteSync(recursive: true)).called(1);
      },
      createDirectory: (name) {
        final mockDir = MockDirectory();
        if (name == screenshotsArg) {
          directory = mockDir;
        }

        when(mockDir.path).thenReturn(name);
        when(mockDir.existsSync()).thenReturn(true);
        when(mockDir.listSync(recursive: nnbd_mockito.anyNamed('recursive')))
            .thenReturn([]);

        return mockDir;
      },
      getCurrentDirectory: () {
        final mockDir = MockDirectory();
        when(mockDir.listSync(recursive: nnbd_mockito.anyNamed('recursive')))
            .thenReturn([File('pubspec.yaml')]);
        return mockDir;
      },
    );
  });
}
