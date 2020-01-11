import 'dart:io';

String platformPath(String path) {
  return Platform.isWindows ? path.replaceAll('/', '\\') : path;
}

bool exists(String path) =>
    path != null && File(platformPath(path)).existsSync();

String get nativeResolutionFile {
  return platformPath('${Directory.current.path}/$_nativeResolutionFile');
}

String get _nativeResolutionFile {
  if (Platform.isWindows) {
    return 'windows/window_configuration.cpp';
  } else if (Platform.isLinux) {
    return 'linux/main.cc';
  }
  assert(false);
  return null;
}
