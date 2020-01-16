// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/commands.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/resolution.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/utils/enum.dart';
import 'package:meta/meta.dart';
import 'package:process_run/shell.dart';

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

  final StreamController<List<int>> output = StreamController();
  final completer = Completer<String>();
  output.stream.transform(utf8.decoder).listen((data) async {
    final match = RegExp(r'is available at: (http://.*/)').firstMatch(data);
    if (match != null) {
      final url = match.group(1);
      logger.trace('Observatory url: $url');
      completer.complete(url);
    }
  });

  final mainFile = _mainDartFile(testFile);
  final command = Commands().flutter.run(mainFile);
  final StreamController<String> input = StreamController();
  final buildProgress = logger.progress('Building and running the application');
  // ignore: unawaited_futures
  Shell(
    stdout: output,
    stdin: input.stream.map(utf8.encode),
  ).run(command).then((_) {
    input.close();
    output.close();
  }).catchError((dynamic _) => printErrorHelp(command));

  final url = await completer.future;
  buildProgress.finish(showTiming: true);

  final stopwatch = Stopwatch()..start();
  await Shell().run(Commands().flutter.dart(testFile, [
    '-u',
    url,
    if (withScreenshots) '-s',
    '-r',
    resolution,
    '-l',
    language,
    if (platform != null) ...['-p', fromEnum(platform)]
  ]));
  logger.stdout(
      'Tests took ${logger.ansi.emphasized('${stopwatch.elapsed.inSeconds}')}s.');

  input.add('q');
}

String _mainDartFile(String testFile) {
  return testFile.endsWith('generic_test.dart')
      ? testFile.replaceFirst('_test.dart', '.dart')
      : platformPath('${File(testFile).parent.path}/generic/generic.dart');
}
