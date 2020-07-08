import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line/command_line.dart'
    as command_line;
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line/streams.dart'
    as streams;
import 'package:fast_flutter_driver_tool/src/preparing_tests/commands.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/logger_extensions.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/resolution.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/utils/enum.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

Future<void> setUp(
  ArgResults args,
  Future<void> Function() test, {
  @required Logger logger,
}) async {
  final String screenResolution = args[resolutionArg];
  if (System.isLinux && screenResolution != null) {
    logger.trace('Overriding resolution');
    await overrideResolution(screenResolution, test, logger: logger);
  } else {
    return test();
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
  @required String device,
  @required TestPlatform platform,
}) async {
  assert(testFile != null);
  logger.stdout('Testing $testFile');
  final mainFile = _mainDartFile(testFile);
  final input = inputFactory();
  final url = await _buildAndRun(
    Commands().flutter.run(mainFile, device),
    input,
    outputFactory,
    run,
    logger,
    device,
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
  String device,
) {
  final completer = Completer<String>();
  final buildProgress = logger.progress('Building application for $device');
  Progress syncingProgress;

  final output = outputFactory((String line) async {
    if (line.contains('Syncing files to')) {
      buildProgress.finish(showTiming: true);
      syncingProgress = logger.progress('Syncing files');
    }
    final match = RegExp('is available at: (http://.*/)').firstMatch(line);
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
      stdout: testOutput,
      stderr: testErrorOutput,
    );
  } finally {
    await testOutput.dispose();
    await testErrorOutput.dispose();
  }
}

String _mainDartFile(String testFile) {
  return testFile.endsWith('generic_test.dart')
      ? testFile.replaceFirst('_test.dart', '.dart')
      : platformPath(_findGenericFile(File(testFile).parent));
}

String _findGenericFile(Directory currentDir) {
  final Directory genericDir =
      currentDir.listSync().whereType<Directory>().firstWhere(
            (directory) =>
                File(join(directory.path, 'generic.dart')).existsSync(),
            orElse: () => null,
          );
  if (genericDir != null) {
    return join(genericDir.path, 'generic.dart');
  } else {
    return _findGenericFile(currentDir.parent);
  }
}
