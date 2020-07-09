// coverage:ignore-file

import 'dart:io';

import 'package:path/path.dart';

// coverage:ignore-start
class PathProvider {
  String get scriptDir => dirname(Platform.script.toFilePath());
}
// coverage:ignore-end
