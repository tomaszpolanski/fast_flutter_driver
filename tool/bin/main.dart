import 'dart:async';
import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line.dart'
    as command_line;
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line_stream.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/test_generator.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/testing.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/update/version.dart';
import 'package:fast_flutter_driver_tool/src/utils/colorizing.dart';

Future<void> main(List<String> paths) async {
  exitCode = 2;
  final parser = scriptParameters;
  final result = parser.parse(paths);
  final logger = result[verboseArg] ? Logger.verbose() : Logger.standard();

  if (result[helpArg] == true) {
    logger..stdout('Usage: fastdriver <path>')..stdout(parser.usage);
    return;
  } else if (result[versionArg] == true) {
    logger.stdout(await currentVersion());
    return;
  }
  // ignore: unawaited_futures
  checkForUpdates();
  final isRootDir = Directory.current.findOrNull('pubspec.yaml') != null;
  if (!isRootDir) {
    logger.stderr(
        'Please run ${bold('fastdriver')} from the root of your project (directory that contains ${bold('pubspec.yaml')})');
    return;
  }

  logger.stdout('Starting tests');

  Directory('build').createSync(recursive: true);
  if (result[screenshotsArg]) {
    final dir = Directory(screenshotsArg);

    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  final testFile = await _testFile(
    (result.rest.length == 1 ? result.rest.first : null) ?? 'test_driver',
    logger,
  );
  if (testFile != null && exists(testFile)) {
    await setUp(result, () async {
      await test(
        outputFactory: output,
        inputFactory: input,
        run: command_line.run,
        logger: logger,
        testFile: testFile,
        withScreenshots: result[screenshotsArg],
        language: result[languageArg],
        resolution: result[resolutionArg],
        platform: TestPlatformEx.fromString(result[platformArg]),
        device: result[deviceArg],
      );
    }, logger: logger);
  } else {
    logger.stderr('Specified path "$testFile" ${red('does not')} exist');
    exitCode = 1;
    return;
  }

  logger.stdout('All ${logger.ansi.emphasized('done')}.');
  exitCode = 0;
}

Future<String> _testFile(String path, Logger logger) async {
  if (File(path).existsSync()) {
    return path;
  } else if (Directory(path).existsSync()) {
    return aggregatedTest(path, logger);
  } else {
    return path;
  }
}
