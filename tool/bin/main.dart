import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
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
import 'package:fast_flutter_driver_tool/src/utils/lazy_logger.dart';
import 'package:http/http.dart' as http;

Future<void> main(List<String> paths) {
  exitCode = 2;
  return run(
    paths,
    loggerFactory: (verbose) => verbose ? Logger.verbose() : Logger.standard(),
    versionCheckerFactory: (logger) => VersionChecker(
      pathProvider: PathProvider(),
      httpGet: http.get,
    ),
    testExecutorFactory: (logger) => TestExecutor(
      outputFactory: output,
      inputFactory: input,
      run: command_line.run,
      logger: logger,
    ),
    testFileProviderFactory: (logger) => TestFileProvider(
      logger: logger,
    ),
  );
}

Future<void> run(
  List<String> paths, {
  required Logger Function(bool) loggerFactory,
  required VersionChecker Function(Logger) versionCheckerFactory,
  required TestExecutor Function(Logger) testExecutorFactory,
  required TestFileProvider Function(Logger) testFileProviderFactory,
}) async {
  final logger = LazyLogger(loggerFactory);
  final parser = scriptParameters;
  final result = _createArguments(() => parser.parse(paths), logger);
  if (result == null) {
    return;
  }
  logger.isVerbose = result[verboseArg];
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
  versionChecker.checkForUpdates().then((AppVersion? version) {
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

  final testFile = await testFileProviderFactory(logger).testFile(
    (result.rest.length == 1 ? result.rest.first : null) ?? 'test_driver',
  );

  if (testFile != null) {
    await setUp(
      result,
      () => testExecutorFactory(logger).test(
        testFile,
        parameters: ExecutorParameters(
          withScreenshots: result[screenshotsArg],
          language: result[languageArg],
          resolution: result[resolutionArg],
          platform: TestPlatformEx.fromString(result[platformArg]),
          device: result[deviceArg],
          flavor: result[flavorArg],
          flutterArguments: result[flutterArg],
          dartArguments: result[dartArg],
          testArguments: result[testArg],
        ),
      ),
      logger: logger,
    );
  } else {
    logger.stderr('Specified path "$testFile" ${red('does not')} exist');
    return;
  }

  logger.stdout('All ${bold('done')}.');
  exitCode = 0;
}

ArgResults _createArguments(ArgResults Function() parse, Logger logger) {
  try {
    return parse();
  } on FormatException catch (e) {
    logger.stderr('''
${e.message}
Try '${green('fastdriver --help')}' for more information.''');
    return null;
  }
}
