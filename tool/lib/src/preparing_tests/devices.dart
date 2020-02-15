import 'dart:io';

String get device {
  if (Platform.isWindows) {
    return 'windows';
  } else if (Platform.isLinux) {
    return 'linux';
  } else {
    return 'macos';
  }
}
