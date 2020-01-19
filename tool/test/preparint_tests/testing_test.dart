import 'dart:convert';
import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line_stream.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line_stream.dart'
    as streams;
import 'package:fast_flutter_driver_tool/src/preparing_tests/testing.dart'
    as tested;
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group('test', () {
    Logger logger;
    setUp(() {
      logger = _MockLogger();
    });

    test('builds application', () {
      final commands = <String>[];
      tested.test(
        outputFactory: streams.output,
        inputFactory: streams.input,
        run: (
          String command, {
          OutputCommandLineStream stdout,
          InputCommandLineStream stdin,
          OutputCommandLineStream stderr,
        }) async {
          commands.add(command);
        },
        logger: logger,
        testFile: 'generic_test.dart',
        withScreenshots: false,
        language: 'pl',
        resolution: '800x600',
        platform: TestPlatform.android,
      );

      expect(
        commands,
        contains(
            'flutter run -d ${Platform.operatingSystem} --target=generic.dart'),
      );
    });

    test('runs tests application', () async {
      final commands = <String>[];
      await tested.test(
        outputFactory: streams.output,
        inputFactory: () {
          return _MockInputCommandLineStream();
        },
        run: (
          String command, {
          OutputCommandLineStream stdout,
          InputCommandLineStream stdin,
          OutputCommandLineStream stderr,
        }) async {
          commands.add(command);
          if (command ==
              'flutter run -d ${Platform.operatingSystem} --target=generic.dart') {
            stdout.stream.add(
              utf8.encode(
                  'is available at: http://127.0.0.1:50512/CKxutzePXlo/'),
            );
          }
        },
        logger: logger,
        testFile: 'generic_test.dart',
        withScreenshots: false,
        language: 'pl',
        resolution: '800x600',
        platform: TestPlatform.android,
      );

      expect(
        commands,
        contains(
            'dart generic_test.dart -u http://127.0.0.1:50512/CKxutzePXlo/ -r 800x600 -l pl -p android'),
      );
    });
  });
}

class _MockLogger extends Mock implements Logger {}

class _MockInputCommandLineStream extends Mock
    implements InputCommandLineStream {}
