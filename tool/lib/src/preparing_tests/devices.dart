import 'package:fast_flutter_driver_tool/src/utils/system.dart';

String get device {
  if (System.isWindows) {
    return 'windows';
  } else if (System.isLinux) {
    return 'linux';
  } else {
    return 'macos';
  }
}
