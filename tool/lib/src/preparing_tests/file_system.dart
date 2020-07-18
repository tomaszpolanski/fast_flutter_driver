import 'dart:io';

import 'package:fast_flutter_driver_tool/src/utils/list.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:path/path.dart' as p;

String platformPath(String path) => p.normalize(path);

bool exists(String? path) =>
    path != null && File(platformPath(path)).existsSync();

String get nativeResolutionFile {
  return platformPath(p.join(Directory.current.path, _nativeResolutionFile));
}

String? get _nativeResolutionFile {
  if (System.isLinux) {
    return [
      'linux/my_application.cc',
      'linux/window_configuration.cc',
    ]
        .map(_getFile)
        .firstWhere((file) => file != null, orElse: () => 'linux/main.cc');
  }
  assert(false);
  return null;
}

String _getFile(String file) {
  final configFile = File(
    platformPath(p.join(
      Directory.current.path,
      file,
    )),
  );
  return configFile.existsSync() ? file : null;
}

bool get isValidRootDirectory =>
    Directory.current.findOrNull('pubspec.yaml') != null;

extension DirectoryEx on Directory {
  String? findOrNull(String name, {bool recursive = false}) {
    return listSync(recursive: recursive)
        .firstWhereOrNull((element) => p.basename(element.path) == name)
        ?.path;
  }
}
