// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:io';

import 'package:args/args.dart';
import 'package:fast_flutter_driver/src/preparing_tests/commands.dart';
import 'package:fast_flutter_driver/src/preparing_tests/file_system.dart';
import 'package:fast_flutter_driver/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver/src/preparing_tests/resolution.dart';
import 'package:fast_flutter_driver/src/preparing_tests/test_generator.dart';
import 'package:fast_flutter_driver/src/running_tests/test/parameters.dart';
import 'package:meta/meta.dart';
import 'package:process_run/shell.dart';

Future<void> setUp(ArgResults args, Future<void> Function() test) {
  final String screenResolution = args[resolutionArg];
  if (Platform.isMacOS || screenResolution == null) {
    return test();
  } else {
    return overrideResolution(screenResolution, test);
  }
}

Future<void> test({
  @required String testFile,
  @required bool withScreenshots,
  @required String resolution,
  String language,
  @required TestPlatform platform,
}) async {
  assert(testFile != null);
  print('Testing $testFile');

  final completer = Completer<String>();

  final StreamController<List<int>> output = StreamController();

  output.stream.transform(utf8.decoder).listen((data) async {
    final match = RegExp(r'is available at: (http://.*/)').firstMatch(data);
    if (match != null) {
      completer.complete(match.group(1));
    }
  });

  if (testFile.endsWith('generic_test.dart')) {
    await generateTestFile(testFile);
  }

  final mainFile = _mainDartFile(testFile);
  final command = Commands().flutter.run(mainFile);
  final StreamController<String> input = StreamController();
  // ignore: unawaited_futures
  Shell(
    stdout: output,
    stdin: input.stream.map(utf8.encode),
  ).run(command).then((_) {
    input.close();
    output.close();
  }).catchError((dynamic _) => printErrorHelp(command));

  final url = await completer.future;

  await Shell().run(Commands().flutter.dart(testFile, [
    '-u',
    url,
    if (withScreenshots) '-s',
    '-r',
    resolution,
    '-l',
    fromEnum(language),
    if (platform != null) ...['-p', fromEnum(platform)]
  ]));

  input.add('q');
}

String _mainDartFile(String testFile) {
  return testFile.endsWith('generic_test.dart')
      ? testFile.replaceFirst('_test.dart', '.dart')
      : platformPath('${File(testFile).parent.path}/generic/generic.dart');
}
