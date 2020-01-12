import 'dart:io';

import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';

class Commands {
  Flutter get flutter => const Flutter._();

  FileSystem get system => const FileSystem._();

  Tests get tests => const Tests._();
}

class Tests {
  const Tests._();

  String testRunner() {
    return Platform.isWindows ? 'test_runner.bat' : './test_runner';
  }
}

class FileSystem {
  const FileSystem._();

  String copy({String source, String destination}) {
    if (Platform.isWindows) {
      return 'copy ${platformPath(source)} ${platformPath(destination)}';
    } else {
      return 'cp -rf ${platformPath(source)} ${platformPath(destination)}';
    }
  }

  String move({String source, String destination}) {
    if (Platform.isWindows) {
      return 'move ${platformPath(source)} ${platformPath(destination)}';
    } else {
      return 'mv ${platformPath(source)} ${platformPath(destination)}';
    }
  }
}

class Flutter {
  const Flutter._();

  String run(String target) {
    return 'flutter run -d $_device --target=$target';
  }

  String attach(String debugUri) {
    return 'flutter attach -d $_device --debug-uri $debugUri';
  }

  String dart(String file, [List<String> arguments]) {
    return 'dart $file ${arguments != null ? arguments.join(' ') : ''}';
  }

  String get _device {
    if (Platform.isWindows) {
      return 'windows';
    } else if (Platform.isLinux) {
      return 'linux';
    } else {
      return 'macos';
    }
  }
}
