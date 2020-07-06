import 'dart:io';

import 'package:fast_flutter_driver_tool/src/preparing_tests/test_generator/test_merger.dart'
    as main_file;
import 'package:file/memory.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  test('creates test file', () {
    File mergedFile;

    IOOverrides.runZoned(
      () async {
        await main_file.main();

        expect(mergedFile, isNotNull);
        expect(mergedFile.path, endsWith('all_tests.dart'));
        expect(mergedFile.readAsStringSync(), isNotEmpty);
      },
      createDirectory: (name) {
        final mockDir = _MockDirectory();

        when(mockDir.path).thenReturn(name);
        final file = _MockFile();
        when(file.path).thenReturn('my_test.dart');
        when(mockDir.listSync(recursive: anyNamed('recursive')))
            .thenReturn([file]);

        return mockDir;
      },
      createFile: (name) {
        if (name.endsWith('all_tests.dart')) {
          return mergedFile = MemoryFileSystem().file(name);
        } else {
          final file = _MockFile();
          when(file.path).thenReturn(name);
          return file;
        }
      },
      getCurrentDirectory: () {
        final file = _MockFile();
        when(file.path).thenReturn('my_test.dart');
        final mockDir = _MockDirectory();
        when(mockDir.listSync(recursive: anyNamed('recursive')))
            .thenReturn([file]);
        when(mockDir.path).thenReturn('/');
        return mockDir;
      },
    );
  });
}

class _MockDirectory extends Mock implements Directory {}

class _MockFile extends Mock implements File {}
