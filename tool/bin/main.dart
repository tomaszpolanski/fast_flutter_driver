// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/test_generator.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/testing.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';

Future<void> main(List<String> paths) async {
  exitCode = -1;
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

  if (result[fileArg] != null) {
    await setUp(
      result,
      () async {
        if (exists(result[fileArg])) {
          await test(
            logger: logger,
            testFile: result[fileArg],
            withScreenshots: result[screenshotsArg],
            language: result[languageArg],
            resolution: result[resolutionArg],
            platform: TestPlatformEx.fromString(result[platformArg]),
          );
        } else {
          logger.stderr('Specified file "${result[fileArg]}" does not exist');
          exitCode = 1;
        }
      },
      logger: logger,
    );
  } else if (result[directoryArg] != null) {
    await setUp(
      result,
      () async {
        await test(
          logger: logger,
          testFile: await aggregatedTest(result[directoryArg], logger),
          withScreenshots: result[screenshotsArg],
          language: result[languageArg],
          resolution: result[resolutionArg],
          platform: TestPlatformEx.fromString(result[platformArg]),
        );
      },
      logger: logger,
    );
  }

  logger.stdout('All ${logger.ansi.emphasized('done')}.');
  exitCode = 0;
}
