// ignore_for_file: avoid_print
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
import 'package:fast_flutter_driver_tool/src/utils/colorizing.dart';

Future<void> main(List<String> paths) async {
  exitCode = 2;
  final parser = scriptParameters;
  final result = parser.parse(paths);
  final logger = result[verboseArg] ? Logger.verbose() : Logger.standard();
  if (result[helpArg] == true) {
    logger.stdout(parser.usage);
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

  final testFile =
      result[fileArg] ?? await aggregatedTest(result[directoryArg], logger);
  if (testFile != null) {
    await setUp(result, () async {
      if (exists(testFile)) {
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
        );
      } else {
        logger.stderr('Specified file "${result[fileArg]}" does not exist');
        exitCode = 1;
        return;
      }
    }, logger: logger);
  } else {
    logger.stderr(
      'Test file setup "${result[directoryArg]}" ${red('does not')} exist',
    );
    exitCode = 1;
    return;
  }

  logger.stdout('All ${logger.ansi.emphasized('done')}.');
  exitCode = 0;
}
