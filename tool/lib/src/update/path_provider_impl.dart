// coverage:ignore-file
import 'dart:io';

import 'package:path/path.dart';

class PathProvider {
  String get scriptDir => dirname(Platform.script.toFilePath());
}
