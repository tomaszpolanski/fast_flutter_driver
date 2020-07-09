import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/update/path_provider_impl.dart';
import 'package:fast_flutter_driver_tool/src/utils/colorizing.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

class VersionChecker {
  VersionChecker({
    @required this.pathProvider,
    @required this.httpGet,
    @required this.logger,
  });

  final PathProvider pathProvider;
  final Future<Response> Function(String url) httpGet;
  final Logger logger;

  Future<String> currentVersion() async {
    final yamlVersion = await _yamlVersion(pathProvider.scriptDir);
    if (yamlVersion == null) {
      return _lockVersion(pathProvider.scriptDir);
    }
    return yamlVersion;
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

  Future<String> _lockVersion(String scriptDir) async {
    final pathToLock = join(scriptDir, '../pubspec.lock');
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

  Future<String> remoteVersion() async {
    final response = await httpGet(
      'https://pub.dev/packages/fast_flutter_driver_tool',
    );

    final match =
        RegExp('fast_flutter_driver_tool (.*)</h2>').firstMatch(response.body);
    if (match == null) {
      throw PackageNotFound();
    }
    return match.group(1);
  }

  Future<AppVersion> checkForUpdates() async {
    try {
      final versions = await Future.wait([currentVersion(), remoteVersion()]);
      final current = versions[0];
      final latest = versions[1];
      if (current != latest) {
        logger
          ..stdout('${green('New version')} (${bold(latest)}) available!')
          ..stdout(
            "To update, run ${green("'pub global activate fast_flutter_driver_tool'")}",
          );
      }
      return AppVersion(local: current, remote: latest);
    } catch (_) {
      // Don't prevent running script because checking version failed
      return null;
    }
  }
}

class PackageNotFound implements Exception {}

class AppVersion {
  const AppVersion({@required this.local, @required this.remote});

  final String local;
  final String remote;
}
