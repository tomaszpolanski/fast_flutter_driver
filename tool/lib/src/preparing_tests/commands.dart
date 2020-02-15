import 'dart:io';

class Commands {
  FlutterCommand get flutter => const FlutterCommand._();
}

class FlutterCommand {
  const FlutterCommand._();

  String run(String target, String device) =>
      'flutter run -d ${device ?? _device} --target=$target';

  String attach(String debugUri, String device) =>
      'flutter attach -d ${device ?? _device} --debug-uri $debugUri';

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
