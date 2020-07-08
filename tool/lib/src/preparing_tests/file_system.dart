import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/utils/colorizing.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:path/path.dart' as p;

String platformPath(String path) => p.normalize(path);

bool exists(String path) =>
    path != null && File(platformPath(path)).existsSync();

String get nativeResolutionFile {
  return platformPath(p.join(Directory.current.path, _nativeResolutionFile));
}

String get _nativeResolutionFile {
  if (System.isLinux) {
    final configFile = File(
      platformPath(p.join(
        Directory.current.path,
        'linux/window_configuration.cc',
      )),
    );
    return configFile.existsSync()
        ? 'linux/window_configuration.cc'
        : 'linux/main.cc';
  }
  assert(false);
  return null;
}

bool validRootDirectory(Logger logger) {
  final isRootDir = Directory.current.findOrNull('pubspec.yaml') != null;
  if (!isRootDir) {
    logger.stderr(
        'Please run ${bold('fastdriver')} from the root of your project (directory that contains ${bold('pubspec.yaml')})');
  }
  return isRootDir;
}

extension DirectoryEx on Directory {
  String findOrNull(String name, {bool recursive = false}) {
    return listSync(recursive: recursive)
        .firstWhere(
          (element) => p.basename(element.path) == name,
          orElse: () => null,
        )
        ?.path;
  }
}
