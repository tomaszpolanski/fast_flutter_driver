// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:io';

import 'package:args/args.dart';
import 'package:fast_flutter_driver/src/src/colorizing.dart';
import 'package:fast_flutter_driver/src/src/commands.dart';
import 'package:fast_flutter_driver/src/src/file_system.dart';
import 'package:fast_flutter_driver/src/src/parameters.dart';
import 'package:fast_flutter_driver/src/src/test_generator.dart';
import 'package:fast_flutter_driver/src/src/tests.dart';
import 'package:meta/meta.dart';
import 'package:process_run/shell.dart';
import 'package:rxdart/rxdart.dart';

const file = 'file';
const directory = 'directory';
const language = 'language';
const screenshots = 'screenshots';
const resolution = 'resolution';
const help = 'help';

Future<void> main(List<String> paths) async {
  stdout.writeln('Starting tests');
  exitCode = -1;
  final parser = createParser();
  final result = parser.parse(paths);
  if (result[help] == true) {
    print(parser.usage);
    return;
  }

  Directory('build').createSync(recursive: true);
  if (result[screenshots]) {
    final dir = Directory(screenshots);

    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  if (result[file] != null) {
    await setUp(result, () async {
      if (exists(result[file])) {
        await test(
          testFile: result[file],
          withScreenshots: result[screenshots],
          language: parseLanguage(result[language]),
          resolution: result[resolution],
          platform: platformFromString(result[platformArg]),
        );
      } else {
        stderr.writeln('Specified file "${result[file]}" does not exist');
        exitCode = 1;
      }
    });
  } else if (result[directory] != null) {
    await setUp(result, () async {
      for (final file in await _tests(result[directory])) {
        await test(
          testFile: file,
          withScreenshots: result[screenshots],
          language: parseLanguage(result[language]),
          resolution: result[resolution],
          platform: platformFromString(result[platformArg]),
        );
      }
    });
  }

  stdout.writeln('Finishing tests');
  exitCode = 0;
}

Future<void> setUp(ArgResults args, Future<void> Function() test) async {
  if (Platform.isMacOS) {
    await test();
  } else {
    final native = platformNativeFile;
    final nativeCopy = '$native\_copy';
    if (exists(native)) {
      await File(native).copy(nativeCopy);
    }

    final String screenResolution = args[resolution];
    if (screenResolution != null) {
      final dimensions = screenResolution.split('x');
      await _updateResolution(
        width: int.parse(dimensions[0]),
        height: int.parse(dimensions[1]),
      );
    }

    try {
      await test();
    } finally {
      if (exists(nativeCopy)) {
        await File(native).delete();
        await File(nativeCopy).rename(native);
      } else {
        stderr.writeln(
            'Was not able to restore native as the copy does not exist');
        exitCode = 1;
      }
    }
  }
}

Future<List<String>> _tests(String directoryPath) => Directory(directoryPath)
    .list(recursive: true)
    .where((file) => file.uri.path.endsWith('_test.dart'))
    .asyncMap((uri) => uri.path)
    .where(
      (path) => File(path.replaceFirst('_test.dart', '.dart')).existsSync(),
    )
    .toList();

ArgParser createParser() {
  return ArgParser()
    ..addOption(
      file,
      abbr: file[0],
      help: 'Run single test file',
    )
    ..addOption(
      directory,
      abbr: directory[0],
      defaultsTo: 'test_driver',
      help: 'Run all the tests in the directory recursively',
    )
    ..addOption(
      language,
      abbr: language[0],
      defaultsTo: 'en',
      help: 'System language, supported languages:\n'
          '${SupportedLanguage.values.map(fromEnum).join(',')}',
    )
    ..addOption(
      platformArg,
      abbr: platformArg[0],
      help: 'Overwritten platform of the device. \n'
          'Possible options: ${TestPlatform.values.map(fromEnum).join(', ')}',
    )
    ..addOption(
      resolution,
      abbr: resolution[0],
      help: 'Resolution of the application '
          'in format <width>x<height>, eg 800x600',
      defaultsTo: '400x700',
    )
    ..addFlag(
      screenshots,
      abbr: screenshots[0],
      help: 'Enables screenshots during test run',
    )
    ..addFlag(
      help,
      abbr: help[0],
      help: 'Display this help message',
      negatable: false,
    );
}

Future<void> test({
  @required String testFile,
  @required bool withScreenshots,
  @required String resolution,
  SupportedLanguage language,
  @required TestPlatform platform,
}) async {
  assert(testFile != null);
  print('Testing $testFile');

  final completer = Completer<String>();

  final StreamController<List<int>> output = StreamController();
  final PublishSubject<String> input = PublishSubject();
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
  // ignore: unawaited_futures
  Shell(
    stdout: output,
    stdin: input.map(utf8.encode),
  ).run(command).then((_) {
    input.close();
    output.close();
  }).catchError((dynamic _) => _displayErrorHelp(command));

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

// ignore: prefer_void_to_null
Future<Null> _displayErrorHelp(String command) async {
  print(
    '''
${red('Failed')} to run command '${yellow(command)}'
To ${green('fix')} it:
  • Close already running application
  • Clean workspace by running:
    ${green('flutter clean')}
  • Enable desktop by running: 
    ${green('flutter config --enable-linux-desktop --enable-macos-desktop --enable-windows-desktop')}'
  • Run the tests again in verbose mode:
    ${green('$command -v')}''',
  );
}

String _mainDartFile(String testFile) {
  return testFile.endsWith('generic_test.dart')
      ? testFile.replaceFirst('_test.dart', '.dart')
      : platformPath('${File(testFile).parent.path}/generic/generic.dart');
}

Future<void> _updateResolution({
  @required int width,
  @required int height,
}) async {
  final path = platformNativeFile;
  final read = await File(path).readAsString();
  final updatedNativeFile = _replaceResolution(
    read,
    width: width,
    height: height,
  );
  await File(path).writeAsString(updatedNativeFile);
}

String _replaceResolution(
  String nativeContent, {
  @required int width,
  @required int height,
}) {
  if (Platform.isWindows) {
    return nativeContent
        .replaceAllMapped(
          RegExp(r'kFlutterWindowWidth = (\d+);'),
          (m) => 'kFlutterWindowWidth = $width;',
        )
        .replaceAllMapped(
          RegExp(r'kFlutterWindowHeight = (\d+);'),
          (m) => 'kFlutterWindowHeight = $height;',
        );
  } else if (Platform.isLinux) {
    return nativeContent
        .replaceAllMapped(
          RegExp(r'window_properties.width = (\d+);'),
          (m) => 'window_properties.width = $width;',
        )
        .replaceAllMapped(
          RegExp(r'window_properties.height = (\d+);'),
          (m) => 'window_properties.height = $height;',
        );
  }
  assert(false);
  return null;
}
