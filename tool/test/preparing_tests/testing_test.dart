import 'dart:convert';
import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line/streams.dart'
    as streams;
import 'package:fast_flutter_driver_tool/src/preparing_tests/devices.dart'
    as devices;
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/testing.dart'
    as test_executor;
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mockito_nnbd.dart' as nnbd_mockito;
import 'testing_test.mocks.dart';

@GenerateMocks(
    [Logger, File, Directory, streams.InputCommandLineStream, Progress])
void main() {
  late Logger logger;
  setUp(() {
    logger = MockLogger();
    when(logger.trace(nnbd_mockito.any)).thenAnswer((_) {});
    when(logger.stdout(nnbd_mockito.any)).thenAnswer((_) {});
    when(logger.progress(nnbd_mockito.any)).thenReturn(_MockProgress(''));
  });

  MockFile createFile() {
    final file = MockFile();
    when(file.existsSync()).thenReturn(true);
    when(file.copy(nnbd_mockito.any)).thenAnswer((_) async => MockFile());
    when(file.writeAsString(nnbd_mockito.any))
        .thenAnswer((_) async => MockFile());
    when(file.delete()).thenAnswer((_) async => MockFile());
    when(file.rename(nnbd_mockito.any)).thenAnswer((_) async => MockFile());
    return file;
  }

  MockInputCommandLineStream createStream() {
    final mock = MockInputCommandLineStream();
    when(mock.write(any)).thenAnswer((_) {});
    when(mock.dispose()).thenAnswer((_) async {});
    return mock;
  }

  group('setup', () {
    tearDown(() {
      linuxOverride = null;
    });

    test('overrides resolution on linux', () async {
      linuxOverride = true;
      final parser = scriptParameters;
      final args = parser.parse(['-r', '1x1']);

      await IOOverrides.runZoned(
        () async {
          await test_executor.setUp(
            args,
            () async {},
            logger: logger,
          );
        },
        getCurrentDirectory: () {
          final mockDir = MockDirectory();
          when(mockDir.path).thenReturn('');
          return mockDir;
        },
        createFile: (name) {
          if (name.endsWith('window_configuration.cc_copy')) {
            final file = createFile();
            when(file.existsSync()).thenReturn(false);
            return file;
          }
          File resolutionFile;
          resolutionFile = createFile();
          when(resolutionFile.existsSync()).thenReturn(true);
          when(resolutionFile.readAsString()).thenAnswer((_) async => '');
          return resolutionFile;
        },
      );

      expect(
        verify(logger.trace(nnbd_mockito.captureAny)).captured.single,
        'Overriding resolution',
      );
    });

    test('runs tests straight away on non linux', () async {
      linuxOverride = false;
      bool haveRunTests = false;

      await test_executor.setUp(
        scriptParameters.parse(['-r', '1x1']),
        () async {
          haveRunTests = true;
        },
        logger: logger,
      );

      verifyNever(logger.trace(nnbd_mockito.any));
      expect(haveRunTests, isTrue);
    });
  });

  group('test', () {
    test_executor.TestExecutor tested;

    test('builds application', () {
      const flavor = 'vanilla';
      final commands = <String>[];
      tested = test_executor.TestExecutor(
        outputFactory: streams.output,
        inputFactory: streams.input,
        run: (
          String command, {
          streams.OutputCommandLineStream? stdout,
          streams.InputCommandLineStream? stdin,
          streams.OutputCommandLineStream? stderr,
        }) async {
          commands.add(command);
        },
        logger: logger,
      );

      // ignore: cascade_invocations
      tested.test(
        'generic_test.dart',
        parameters: test_executor.ExecutorParameters(
          withScreenshots: false,
          language: 'pl',
          resolution: '800x600',
          platform: TestPlatform.android,
          device: devices.device,
          flavor: flavor,
          dartArguments: '',
          flutterArguments: '',
          testArguments: '',
        ),
      );

      expect(
        commands,
        contains(
          'flutter run -d ${devices.device} '
          '--target=generic.dart '
          '--flavor $flavor ',
        ),
      );
    });

    test('passes flutter arguments', () {
      const arguments = '--device-user=10 --host-vmservice-port';
      final commands = <String>[];
      tested = test_executor.TestExecutor(
        outputFactory: streams.output,
        inputFactory: streams.input,
        run: (
          String command, {
          required streams.OutputCommandLineStream stdout,
          streams.InputCommandLineStream? stdin,
          streams.OutputCommandLineStream? stderr,
        }) async {
          commands.add(command);
        },
        logger: logger,
      );

      // ignore: cascade_invocations
      tested.test(
        'generic_test.dart',
        parameters: test_executor.ExecutorParameters(
          withScreenshots: false,
          language: 'pl',
          resolution: '800x600',
          platform: TestPlatform.android,
          device: devices.device,
          flutterArguments: arguments,
          dartArguments: '',
          testArguments: '',
        ),
      );

      expect(
        commands,
        contains(
          'flutter run -d ${devices.device} '
          '--target=generic.dart '
          '$arguments',
        ),
      );
    });

    test('builds application for specific device', () {
      final commands = <String>[];
      const device = 'some_special_device';
      tested = test_executor.TestExecutor(
        outputFactory: streams.output,
        inputFactory: streams.input,
        run: (
          String command, {
          required streams.OutputCommandLineStream stdout,
          streams.InputCommandLineStream? stdin,
          streams.OutputCommandLineStream? stderr,
        }) async {
          commands.add(command);
        },
        logger: logger,
      );

      // ignore: cascade_invocations
      tested.test(
        'generic_test.dart',
        parameters: const test_executor.ExecutorParameters(
          withScreenshots: false,
          language: 'pl',
          resolution: '800x600',
          platform: TestPlatform.android,
          device: device,
          dartArguments: '',
          flutterArguments: '',
          testArguments: '',
        ),
      );

      expect(
        commands,
        contains('flutter run -d $device --target=generic.dart '),
      );
    });

    group('runs tests application', () {
      test('on native', () async {
        final commands = <String>[];
        const url = 'http://127.0.0.1:50512/CKxutzePXlo/';
        tested = test_executor.TestExecutor(
          outputFactory: streams.output,
          inputFactory: createStream,
          run: (
            String command, {
            required streams.OutputCommandLineStream stdout,
            streams.InputCommandLineStream? stdin,
            streams.OutputCommandLineStream? stderr,
          }) async {
            print('QQQQQQQ ${command}');
            commands.add(command);
            if (command.startsWith(
                'flutter run -d ${devices.device} --target=generic.dart')) {
              stdout.stream.add(
                utf8.encode('is available at: $url'),
              );
            }
          },
          logger: logger,
        );
        await tested.test(
          'generic_test.dart',
          parameters: test_executor.ExecutorParameters(
            withScreenshots: false,
            language: 'pl',
            resolution: '800x600',
            platform: TestPlatform.android,
            device: devices.device,
            dartArguments: '',
            flutterArguments: '',
            testArguments: '',
          ),
        );

        expect(
          commands,
          contains(
              'dart generic_test.dart -u http://127.0.0.1:50512/CKxutzePXlo/ -r 800x600 -l pl -p android'),
        );
      });

      test('on web', () async {
        final commands = <String>[];
        const url = 'ws://127.0.0.1:52464/rjc_-3ZH0N0=';
        tested = test_executor.TestExecutor(
          outputFactory: streams.output,
          inputFactory: createStream,
          run: (
            String command, {
            required streams.OutputCommandLineStream stdout,
            streams.InputCommandLineStream? stdin,
            streams.OutputCommandLineStream? stderr,
          }) async {
            commands.add(command);
            if (command.startsWith(
                'flutter run -d ${devices.device} --target=generic.dart')) {
              stdout.stream.add(
                utf8.encode('Debug service listening on $url'),
              );
            }
          },
          logger: logger,
        );
        await tested.test(
          'generic_test.dart',
          parameters: test_executor.ExecutorParameters(
            withScreenshots: false,
            language: 'pl',
            resolution: '800x600',
            platform: TestPlatform.android,
            device: devices.device,
            dartArguments: '',
            flutterArguments: '',
            testArguments: '',
          ),
        );

        expect(
          commands,
          contains(
              'dart generic_test.dart -u $url -r 800x600 -l pl -p android'),
        );
      });
    });

    test('passes dart arguments', () async {
      const dartArgs = '--enable-experiment=non-nullable';
      final commands = <String>[];
      tested = test_executor.TestExecutor(
        outputFactory: streams.output,
        inputFactory: createStream,
        run: (
          String command, {
          required streams.OutputCommandLineStream stdout,
          streams.InputCommandLineStream? stdin,
          streams.OutputCommandLineStream? stderr,
        }) async {
          commands.add(command);
          if (command.startsWith(
              'flutter run -d ${devices.device} --target=generic.dart')) {
            stdout.stream.add(
              utf8.encode(
                  'is available at: http://127.0.0.1:50512/CKxutzePXlo/'),
            );
          }
        },
        logger: logger,
      );
      await tested.test(
        'generic_test.dart',
        parameters: test_executor.ExecutorParameters(
          withScreenshots: false,
          language: 'pl',
          resolution: '800x600',
          platform: TestPlatform.android,
          device: devices.device,
          dartArguments: dartArgs,
          flutterArguments: '',
          testArguments: '',
        ),
      );

      expect(
        commands,
        contains(
          'dart $dartArgs generic_test.dart -u http://127.0.0.1:50512/CKxutzePXlo/ -r 800x600 -l pl -p android',
        ),
      );
    });

    test('passes test arguments', () async {
      const testArgs = 'additional arguments';
      final commands = <String>[];
      tested = test_executor.TestExecutor(
        outputFactory: streams.output,
        inputFactory: createStream,
        run: (
          String command, {
          required streams.OutputCommandLineStream stdout,
          streams.InputCommandLineStream? stdin,
          streams.OutputCommandLineStream? stderr,
        }) async {
          commands.add(command);
          if (command.startsWith(
              'flutter run -d ${devices.device} --target=generic.dart')) {
            stdout.stream.add(
              utf8.encode(
                  'is available at: http://127.0.0.1:50512/CKxutzePXlo/'),
            );
          }
        },
        logger: logger,
      );
      await tested.test(
        'generic_test.dart',
        parameters: test_executor.ExecutorParameters(
          withScreenshots: false,
          language: 'pl',
          resolution: '800x600',
          platform: TestPlatform.android,
          device: devices.device,
          testArguments: testArgs,
          dartArguments: '',
          flutterArguments: '',
        ),
      );

      expect(
        commands,
        contains(
          'dart generic_test.dart -u http://127.0.0.1:50512/CKxutzePXlo/ -r 800x600 -l pl -p android --test-args "$testArgs"',
        ),
      );
    });
  });
}

class _MockProgress extends Progress {
  _MockProgress(String message) : super(message);

  @override
  void cancel() {
    // TODO: implement cancel
  }

  @override
  void finish({String? message, bool showTiming = false}) {
    // TODO: implement finish
  }
}
