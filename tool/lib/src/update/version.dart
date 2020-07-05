// ignore_for_file: avoid_print
import 'dart:io';

import 'package:fast_flutter_driver_tool/src/update/path_provider.dart';
import 'package:fast_flutter_driver_tool/src/utils/colorizing.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

Future<String> currentVersion(PathProvider paths) async {
  return (await _yamlVersion(paths.scriptDir)) ?? (await _lockVersion());
}

Future<String> _yamlVersion(String scriptDir) async {
  final pathToYaml = join(scriptDir, '../pubspec.yaml');
  final file = File(pathToYaml);
  if (file.existsSync()) {
    final yaml = loadYaml(await file.readAsString());
    return yaml['version'];
  }
  return null;
}

Future<String> _lockVersion() async {
  final pathToLock =
      join(dirname(Platform.script.toFilePath()), '../pubspec.lock');
  bool foundPackage = false;
  for (final line in await File(pathToLock).readAsLines()) {
    if (line.contains('fast_flutter_driver_tool')) {
      foundPackage = true;
    } else if (foundPackage) {
      final version = RegExp('version: "(.*)"').firstMatch(line)?.group(1);
      if (version != null) {
        return version;
      }
    }
  }
  return null;
}

class PackageNotFound implements Exception {}

Future<String> remoteVersion(
    Future<Response> Function(String url) httpGet) async {
  final response =
      await httpGet('https://pub.dev/packages/fast_flutter_driver_tool');

  final match =
      RegExp('fast_flutter_driver_tool (.*)</h2>').firstMatch(response.body);
  if (match == null) {
    throw PackageNotFound();
  }
  return match.group(1);
}

Future<void> checkForUpdates() async {
  try {
    final versions = await Future.wait(
        [currentVersion(PathProvider()), remoteVersion(http.get)]);
    final current = versions[0];
    final latest = versions[1];
    if (current != latest) {
      print('${green('New version')} (${bold(latest)}) available!');
      print(
        "To update, run ${green("'pub global activate fast_flutter_driver_tool'")}",
      );
    }
  } catch (_) {
    // Don't prevent running script because checking version failed
  }
}
