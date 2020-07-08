import 'dart:io';

import 'package:fast_flutter_driver_tool/src/preparing_tests/resolution.dart';
import 'package:fast_flutter_driver_tool/src/utils/system.dart';
import 'package:file/memory.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  File resolutionFile;
  setUp(() {
    const content = '''
const unsigned int kFlutterWindowWidth = 800;
const unsigned int kFlutterWindowHeight = 600;
''';
    resolutionFile = MemoryFileSystem().file('window_configuration.cc')
      ..writeAsStringSync(content);
  });

  tearDown(() {
    linuxOverride = null;
  });

  test('replace resolution', () {
    IOOverrides.runZoned(
      () async {
        linuxOverride = true;
        await overrideResolution('1x2', () async {
          const content = '''
const unsigned int kFlutterWindowWidth = 1;
const unsigned int kFlutterWindowHeight = 2;
''';
          final tested = resolutionFile.readAsStringSync();
          expect(tested, content);
        });
      },
      getCurrentDirectory: () {
        final mockDir = _MockDirectory();
        when(mockDir.path).thenReturn('');
        return mockDir;
      },
      createFile: (name) {
        if (name.endsWith('window_configuration.cc_copy')) {
          final file = _MockFile();
          when(file.existsSync()).thenReturn(true);
          return file;
        }
        return resolutionFile;
      },
    );
  });
}

class _MockDirectory extends Mock implements Directory {}

class _MockFile extends Mock implements File {}
