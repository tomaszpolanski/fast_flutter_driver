// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line_stream.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/commands.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
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
  @required Logger logger,
  @required String testFile,
  @required bool withScreenshots,
  @required String resolution,
  String language,
  @required TestPlatform platform,
}) async {
  assert(testFile != null);
  logger.stdout('Testing $testFile');

  final completer = Completer<String>();
  final buildProgress = logger.progress('Building application');
  Progress syncingProgress;

  final mainFile = _mainDartFile(testFile);
  final flutterRunCommand = Commands().flutter.run(mainFile);
  final input = InputCommandLineStream();
  final output = OutputCommandLineStream((String line) async {
    if (line.contains('Syncing files to')) {
      buildProgress.finish(showTiming: true);
      syncingProgress = logger.progress('Syncing files');
    }
    final match = RegExp(r'is available at: (http://.*/)').firstMatch(line);
    if (match != null) {
      final url = match.group(1);
      logger.trace('Observatory url: $url');
      completer.complete(url);
    }
  });
  // ignore: unawaited_futures
  CommandLine(stdout: output, stdin: input).run(flutterRunCommand).then((_) {
    input.dispose();
    output.dispose();
  }).catchError((dynamic _) => printErrorHelp(flutterRunCommand));

  final url = await completer.future;
  syncingProgress?.finish(showTiming: true);

  final testOutput = OutputCommandLineStream((line) async {
    line = line.trim();
    if (logger.isVerbose) {
      logger.trace(line);
    } else {
      if (line.isEmpty ||
          line.startsWith('DriverError') ||
          line.startsWith('===') ||
          line.startsWith('_rootRun') ||
          line.startsWith('package:')) {
        return;
      }
      logger.stdout(line);
    }
  });

  final testErrorOutput = OutputCommandLineStream((line) async {
    line = line.trim();
    if (logger.isVerbose) {
      logger.trace(line);
    } else {
      if (line.isEmpty ||
          line.startsWith('[trace]') ||
          line.startsWith('[info ]')) {
        return;
      }
      logger.stderr(line);
    }
  });

  try {
    await CommandLine(
      stdout: testOutput,
      stderr: testErrorOutput,
    ).run(Commands().flutter.dart(testFile, [
      '-u',
      url,
      if (withScreenshots) '-s',
      '-r',
      resolution,
      '-l',
      language,
      if (platform != null) ...['-p', fromEnum(platform)]
    ]));
  } finally {
    await testOutput.dispose();
    await testErrorOutput.dispose();
    input.write('q');
  }
}

String _mainDartFile(String testFile) {
  return testFile.endsWith('generic_test.dart')
      ? testFile.replaceFirst('_test.dart', '.dart')
      : platformPath('${File(testFile).parent.path}/generic/generic.dart');
}
