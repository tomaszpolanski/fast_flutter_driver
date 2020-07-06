import 'dart:io';

import 'package:fast_flutter_driver_tool/src/preparing_tests/file_system.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/test_generator/test_generator.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  final testDir = Directory(p.join(Directory.current.path, 'test'));
  final genericTestFile =
      File(platformPath(p.join(testDir.path, 'all_tests.dart')));
  if (!genericTestFile.existsSync()) {
    genericTestFile.createSync();
  }
  await generateTestFile(genericTestFile, testDir, '../../');
}
