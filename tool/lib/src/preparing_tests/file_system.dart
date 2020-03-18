import 'dart:io';

import 'package:path/path.dart' as p;

String platformPath(String path) => p.normalize(path);

bool exists(String path) =>
    path != null && File(platformPath(path)).existsSync();

String get nativeResolutionFile {
  return platformPath(p.join(Directory.current.path, _nativeResolutionFile));
}

String get _nativeResolutionFile {
  if (Platform.isWindows) {
    return 'windows/window_configuration.cpp';
  } else if (Platform.isLinux) {
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
