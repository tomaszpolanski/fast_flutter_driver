// ignore_for_file: avoid_print
import 'dart:io';

import 'package:fast_flutter_driver_tool/src/utils/colorizing.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

Future<String> currentVersion() async {
  final pathToYaml =
      join(dirname(Platform.script.toFilePath()), '../pubspec.yaml');
  final yaml = loadYaml(await File(pathToYaml).readAsString());
  return yaml['version'];
}

Future<String> remoteVersion() async {
  final response =
      await http.get('https://pub.dev/packages/fast_flutter_driver_tool');

  return RegExp(r'fast_flutter_driver_tool (.*)</h2>')
      .firstMatch(response.body)
      .group(1);
}

Future<void> checkForUpdates() async {
  try {
    final versions = await Future.wait([currentVersion(), remoteVersion()]);
    final current = versions[0];
    final latest = versions[1];
    if (current != latest) {
      print('${green('New verison')} (${bold(latest)}) available!');
      print(
        "To update, run ${green('\'pub global activate fast_flutter_driver_tool\'')}",
      );
    }
  } catch (_) {
    // Don't prevent running script because checking version failed
  }
}
