// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line.dart'
    as command_line;
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line_stream.dart'
    as streams;
import 'package:fast_flutter_driver_tool/src/preparing_tests/commands.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/resolution.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/utils/enum.dart';
import 'package:meta/meta.dart';

Future<void> setUp(
  ArgResults args,
  Future<void> Function() test, {
  @required Logger logger,
}) async {
  final String screenResolution = args[resolutionArg];
  if (Platform.isMacOS || screenResolution == null) {
    return test();
  } else {
    logger.trace('Overriding resolution');
    await overrideResolution(screenResolution, test);
  }
}

Future<void> test({
  @required streams.OutputFactory outputFactory,
  @required streams.InputFactory inputFactory,
  @required command_line.RunCommand run,
  @required Logger logger,
  @required String testFile,
  @required bool withScreenshots,
  @required String resolution,
  String language,
  @required TestPlatform platform,
}) async {
  assert(testFile != null);
  logger.stdout('Testing $testFile');

  final mainFile = _mainDartFile(testFile);
  final input = inputFactory();
  final url = await _buildAndRun(
    Commands().flutter.run(mainFile),
    input,
    outputFactory,
    run,
    logger,
  );

  final runTestCommand = Commands().flutter.dart(testFile, {
    '-u': url,
    if (withScreenshots) '-${screenshotsArg[0]}': '',
    '-${resolutionArg[0]}': resolution,
    '-${languageArg[0]}': language,
    if (platform != null) '-${platformArg[0]}': fromEnum(platform),
  });

  try {
    await _runTests(runTestCommand, outputFactory, run, logger);
  } finally {
    input.write('q');
    await input.dispose();
  }
}

Future<String> _buildAndRun(
  String command,
  streams.InputCommandLineStream input,
  streams.OutputFactory outputFactory,
  command_line.RunCommand run,
  Logger logger,
) {
  final completer = Completer<String>();
  final buildProgress = logger.progress('Building application');
  Progress syncingProgress;

  final output = outputFactory((String line) async {
    if (line.contains('Syncing files to')) {
      buildProgress.finish(showTiming: true);
      syncingProgress = logger.progress('Syncing files');
    }
    final match = RegExp(r'is available at: (http://.*/)').firstMatch(line);
    if (match != null) {
      syncingProgress?.finish(showTiming: true);
      final url = match.group(1);
      logger.trace('Observatory url: $url');
      completer.complete(url);
    }
  });
  // ignore: unawaited_futures
  run(command, stdout: output, stdin: input).then((_) {
    output.dispose();
  }).catchError((dynamic _) => printErrorHelp(command));

  return completer.future;
}

Future<void> _runTests(
  String command,
  streams.OutputFactory outputFactory,
  command_line.RunCommand run,
  Logger logger,
) async {
  final testOutput = outputFactory((line) {
    logger.printTestOutput(
      line,
      ['DriverError', '===', '_rootRun', '===package:'],
    );
  });

  final testErrorOutput = outputFactory((line) {
    logger.printTestError(line, ['[trace]', '[info ]']);
  });

  try {
    await run(
      command,
      stdout: testOutput,
      stderr: testErrorOutput,
    );
  } finally {
    await testOutput.dispose();
    await testErrorOutput.dispose();
  }
}

String _mainDartFile(String testFile) {
  return testFile.replaceFirst('_test.dart', '.dart');
}

extension on Logger {
  void printTestError(String line, List<String> blackListed) {
    _print(line, blackListed, this.stderr);
  }

  void printTestOutput(String line, List<String> blackListed) {
    _print(line, blackListed, this.stdout);
  }

  void _print(
    String line,
    List<String> blackListed,
    void Function(String) print,
  ) {
    if (isVerbose) {
      trace(line);
    } else {
      if (line.isEmpty || blackListed.any(line.startsWith)) {
        return;
      }
      print(line);
    }
  }
}
