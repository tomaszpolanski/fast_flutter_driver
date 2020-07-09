import 'dart:async';
import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line/command_line_impl.dart'
    as command_line;
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line/streams.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/test_generator/test_generator.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/testing.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/update/path_provider_impl.dart';
import 'package:fast_flutter_driver_tool/src/update/version.dart';
import 'package:fast_flutter_driver_tool/src/utils/colorizing.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

Future<void> main(List<String> paths) {
  exitCode = 2;
  return run(
    paths,
    loggerFactory: (verbose) => verbose ? Logger.verbose() : Logger.standard(),
    versionCheckerFactory: (logger) => VersionChecker(
      pathProvider: PathProvider(),
      httpGet: http.get,
    ),
  );
}

Future<void> run(
  List<String> paths, {
  @required Logger Function(bool) loggerFactory,
  @required VersionChecker Function(Logger) versionCheckerFactory,
}) async {
  final parser = scriptParameters;
  final result = parser.parse(paths);
  final logger = loggerFactory(result[verboseArg]);
  final versionChecker = versionCheckerFactory(logger);

  if (result[helpArg] == true) {
    logger.stdout('Usage: fastdriver <path>\n${parser.usage}');
    return;
  } else if (result[versionArg] == true) {
    logger.stdout(await versionChecker.currentVersion());
    return;
  } else if (!isValidRootDirectory) {
    logger.stderr(
        'Please run ${bold('fastdriver')} from the root of your project '
        '(directory that contains ${bold('pubspec.yaml')})');
    return;
  }
  // ignore: unawaited_futures
  versionChecker.checkForUpdates().then((AppVersion version) {
    if (version != null && version.local != version.remote) {
      {
        logger
          ..stdout(
              '${green('New version')} (${bold(version.remote)}) available!')
          ..stdout(
            "To update, run ${green("'pub global activate fast_flutter_driver_tool'")}",
          );
      }
    }
  });

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
    await setUp(
      result,
      () => test(
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
      ),
      logger: logger,
    );
  } else {
    logger.stderr('Specified path "$testFile" ${red('does not')} exist');
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
