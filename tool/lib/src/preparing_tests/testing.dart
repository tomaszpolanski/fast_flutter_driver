import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line/command_line_impl.dart'
    as command_line;
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line/streams.dart'
    as streams;
import 'package:fast_flutter_driver_tool/src/preparing_tests/commands.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/logger_extensions.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/resolution.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/utils/colorizing.dart';
import 'package:fast_flutter_driver_tool/src/utils/enum.dart';
import 'package:fast_flutter_driver_tool/src/utils/list.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:path/path.dart';

Future<void> setUp(
  ArgResults args,
  Future<void> Function() test, {
  required Logger logger,
}) async {
  final String? screenResolution = args[resolutionArg];
  if (System.isLinux && screenResolution != null) {
    logger.trace('Overriding resolution');
    await overrideResolution(screenResolution, test, logger: logger);
  } else {
    return test();
  }
}

class ExecutorParameters {
  const ExecutorParameters({
    required this.withScreenshots,
    required this.resolution,
    required this.language,
    required this.device,
    this.platform,
    required this.flutterArguments,
    required this.dartArguments,
    required this.testArguments,
    this.flavor,
  });

  final bool withScreenshots;
  final String resolution;
  final String language;
  final String device;
  final TestPlatform? platform;
  final String? flavor;
  final String? flutterArguments;
  final String? dartArguments;
  final String? testArguments;
}

class TestExecutor {
  const TestExecutor({
    required this.outputFactory,
    required this.inputFactory,
    required this.run,
    required this.logger,
  });

  final streams.OutputFactory outputFactory;
  final streams.InputFactory inputFactory;
  final command_line.RunCommand run;
  final Logger logger;

  Future<void> test(
    String testFile, {
    required ExecutorParameters parameters,
  }) async {
    {
      logger.stdout('Testing $testFile');
      final mainFile = _mainDartFile(testFile);
      final input = inputFactory();
      final url = await _buildAndRun(
        Commands().flutter.run(
              mainFile,
              parameters.device,
              flavor: parameters.flavor,
              additionalArguments: parameters.flutterArguments,
            ),
        input,
        outputFactory,
        run,
        logger,
        parameters.device,
      );
      final platform = parameters.platform;
      final runTestCommand = Commands().flutter.dart(
        testFile,
        dartArguments: parameters.dartArguments,
        testArguments: {
          '-u': url,
          if (parameters.withScreenshots) '-${screenshotsArg[0]}': '',
          '-${resolutionArg[0]}': parameters.resolution,
          '-${languageArg[0]}': parameters.language,
          if (platform != null) '-${platformArg[0]}': fromEnum(platform),
          if (parameters.testArguments?.isNotEmpty == true)
            '--$testArg': '"${parameters.testArguments}"',
        },
      );

      try {
        await _runTests(runTestCommand, outputFactory, run, logger);
      } catch (e) {
        logger.stderr(
          '${red('Failed')} to run:\n'
          'If you are using not yet migrated ${bold('flutter driver')} '
          'please pass ${bold('no-sound')} null safety flags:\n'
          '${green('fastdriver --dart-args "--no-sound-null-safety" '
              '--flutter-args "--no-sound-null-safety"')}\n',
        );
        rethrow;
      } finally {
        input.write('q');
        await input.dispose();
      }
    }
  }

  Future<String> _buildAndRun(
    String command,
    streams.InputCommandLineStream input,
    streams.OutputFactory outputFactory,
    command_line.RunCommand run,
    Logger logger,
    String device,
  ) {
    final completer = Completer<String>();
    final buildProgress = logger.progress('Building application for $device');
    Progress? syncingProgress;

    final output = outputFactory((String line) async {
      logger.trace(line);
      if (line.contains('Syncing files to')) {
        buildProgress.finish(showTiming: true);
        syncingProgress = logger.progress('Syncing files');
      }
      final nativeMatch = RegExp(
              'An Observatory debugger and profiler on .* is available at: (http://.*/)')
          .firstMatch(line);
      final webMatch =
          RegExp('service listening on (ws://.*)').firstMatch(line);
      final match = nativeMatch ?? webMatch;
      if (match != null) {
        syncingProgress?.finish(showTiming: true);
        final url = match.group(1);
        logger.trace('Observatory url: $url');
        completer.complete(url);
      }
    });

    logger.trace('Running $command');
    run(command, output, stdin: input).then((_) {
      output.dispose();
      // ignore: return_of_invalid_type_from_catch_error
    }).catchError((dynamic _) => printErrorHelp(command, logger: logger));

    return completer.future;
  }

  Future<void> _runTests(
    String command,
    streams.OutputFactory outputFactory,
    command_line.RunCommand run,
    Logger logger,
  ) async {
    const notShowLines = [
      'DriverError',
      '===',
      '_rootRun',
      '===package:',
      '[trace]',
      '[info ]',
      'FlutterDriver',
      'VMServiceFlutterDriver'
    ];
    final testOutput = outputFactory((line) {
      logger.printTestOutput(line, notShowLines);
    });

    final testErrorOutput = outputFactory((line) {
      logger.printTestError(line, notShowLines);
    });

    try {
      await run(
        command,
        testOutput,
        stderr: testErrorOutput,
      );
    } finally {
      await testOutput.dispose();
      await testErrorOutput.dispose();
    }
  }
}

String _mainDartFile(String testFile) {
  return testFile.endsWith('generic_test.dart')
      ? testFile.replaceFirst('_test.dart', '.dart')
      : platformPath(_findGenericFile(File(testFile).parent));
}

String _findGenericFile(Directory currentDir) {
  final genericDir =
      currentDir.listSync().whereType<Directory>().firstWhereOrNull(
            (directory) =>
                File(join(directory.path, 'generic.dart')).existsSync(),
          );
  if (genericDir != null) {
    return join(genericDir.path, 'generic.dart');
  } else {
    return _findGenericFile(currentDir.parent);
  }
}
