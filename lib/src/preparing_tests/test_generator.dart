import 'dart:io';

import 'package:fast_flutter_driver/src/preparing_tests/file_system.dart';

Future<void> generateTestFile(String testFile) {
  final testFiles = Directory(File(testFile).parent.parent.path)
      .listSync(recursive: true)
      .where((file) => file.path.endsWith('_test.dart'))
      .where((file) => !file.path.endsWith('generic_test.dart'))
      .map((file) => file.path)
      .toList(growable: false);
  return _writeGeneratedTest(testFiles, testFile);
}

Future<void> _writeGeneratedTest(List<String> testFiles, String path) async {
  final file = File(platformPath('${File(path).parent.path}/generic_test.dart'))
      .openWrite()
        ..writeln('// ignore_for_file: directives_ordering')
        ..writeln('');
  for (final test in testFiles) {
    file.writeln(
        'import \'../../${test.replaceAll('\\', '/')}\' as ${_importName(test)};');
  }
  file..writeln('')..writeln('void main(List<String> args) {');
  for (final test in testFiles) {
    file.writeln('  ${_importName(test)}.main(args);');
  }
  file.writeln('}');
  await file.close();
}

String _importName(String path) {
  return path
      .replaceAll('/', '_')
      .replaceAll('\\', '_')
      .replaceAll('_test.dart', '');
}
