import 'dart:io';

import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../bin/main.dart' as main_file;

void main() {
  test('deletes screenshots if the folder exists and passing the flag', () {
    Directory directory;

    IOOverrides.runZoned(
      () async {
        await main_file.main(['-s']);

        verify(directory.deleteSync(recursive: true)).called(1);
      },
      createDirectory: (name) {
        final mockDir = _MockDirectory();
        if (name == screenshotsArg) {
          directory = mockDir;
        }

        when(mockDir.path).thenReturn(name);
        when(mockDir.existsSync()).thenReturn(true);
        when(mockDir.listSync(recursive: anyNamed('recursive'))).thenReturn([]);

        return mockDir;
      },
      getCurrentDirectory: () {
        final mockDir = _MockDirectory();
        when(mockDir.listSync(recursive: anyNamed('recursive')))
            .thenReturn([File('pubspec.yaml')]);
        return mockDir;
      },
    );
  });
}

class _MockDirectory extends Mock implements Directory {}
