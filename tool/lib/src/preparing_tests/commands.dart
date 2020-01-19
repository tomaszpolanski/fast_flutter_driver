import 'dart:io';

class Commands {
  Flutter get flutter => const Flutter._();
}

class Flutter {
  const Flutter._();

  String run(String target) => 'flutter run -d $_device --target=$target';

  String attach(String debugUri) =>
      'flutter attach -d $_device --debug-uri $debugUri';

  String dart(String file, [Map<String, String> arguments]) {
    final args = arguments?.entries
        ?.map((entry) =>
            '${entry.key}${entry.value.isNotEmpty ? ' ${entry.value}' : ''}')
        ?.join(' ');
    return 'dart $file ${args ?? ''}';
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
