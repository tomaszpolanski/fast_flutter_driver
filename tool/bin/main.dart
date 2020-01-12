// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';

import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/testing.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';

Future<void> main(List<String> paths) async {
  stdout.writeln('Starting tests');
  exitCode = -1;
  final parser = scriptParameters;
  final result = parser.parse(paths);
  if (result[helpArg] == true) {
    print(parser.usage);
    return;
  }

  Directory('build').createSync(recursive: true);
  if (result[screenshotsArg]) {
    final dir = Directory(screenshotsArg);

    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  if (result[fileArg] != null) {
    await setUp(result, () async {
      if (exists(result[fileArg])) {
        await test(
          testFile: result[fileArg],
          withScreenshots: result[screenshotsArg],
          language: result[languageArg],
          resolution: result[resolutionArg],
          platform: TestPlatformEx.fromString(result[platformArg]),
        );
      } else {
        stderr.writeln('Specified file "${result[fileArg]}" does not exist');
        exitCode = 1;
      }
    });
  } else if (result[directoryArg] != null) {
    await setUp(result, () async {
      for (final file in await _tests(result[directoryArg])) {
        await test(
          testFile: file,
          withScreenshots: result[screenshotsArg],
          language: result[languageArg],
          resolution: result[resolutionArg],
          platform: TestPlatformEx.fromString(result[platformArg]),
        );
      }
    });
  }

  stdout.writeln('Finishing tests');
  exitCode = 0;
}

Future<List<String>> _tests(String directoryPath) => Directory(directoryPath)
    .list(recursive: true)
    .where((file) => file.uri.path.endsWith('_test.dart'))
    .asyncMap((uri) => uri.path)
    .where(
      (path) => File(path.replaceFirst('_test.dart', '.dart')).existsSync(),
    )
    .toList();
