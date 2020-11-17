import 'package:meta/meta.dart';

class Commands {
  FlutterCommand get flutter => const FlutterCommand._();
}

class FlutterCommand {
  const FlutterCommand._();

  String run(
    String target,
    String device, {
    @required String flavor,
    String additionalArguments,
  }) {
    // ignore: missing_whitespace_between_adjacent_strings
    return 'flutter run -d $device --target=$target'
        '${flavor != null ? ' --flavor $flavor' : ''}'
        '${additionalArguments != null ? ' $additionalArguments' : ''}';
  }

  String attach(String debugUri, String device) =>
      'flutter attach -d $device --debug-uri $debugUri';

  String dart(
    String file, {
    Map<String, String> testArguments,
    String dartArguments,
  }) {
    final args = testArguments?.entries
        ?.map((entry) =>
            '${entry.key}${entry.value.isNotEmpty ? ' ${entry.value}' : ''}')
        ?.join(' ');

    return 'dart'
        '${dartArguments != null ? ' $dartArguments' : ''}'
        // ignore: missing_whitespace_between_adjacent_strings
        ' $file'
        '${args != null ? ' $args' : ''}';
  }
}
