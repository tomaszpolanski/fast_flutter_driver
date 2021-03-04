import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/test_generator/test_generator.dart';
import 'package:file/memory.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../mocks/mock_file.dart';
import 'test_generator_test.mocks.dart';

@GenerateMocks([
  Directory,
  Logger,
  TestGenerator,
])
void main() {
  group('testFiles', () {
    late TestGenerator generator;
    setUp(() {
      generator = TestGenerator();
    });

    test('list test file', () {
      const testName = 'my_test.dart';
      final mockDir = _MockDirectory()..fieldListSync = [File(testName)];

      final tested = generator.testFiles(mockDir, 'any');

      expect(tested, contains(testName));
    });

    test('skips non test files', () {
      const testName = 'my.dart';
      final mockDir = _MockDirectory()..fieldListSync = [File(testName)];

      final tested = generator.testFiles(mockDir, 'any');

      expect(tested, isEmpty);
    });

    test('skips excluded file', () {
      const testName = 'my_test.dart';
      final mockDir = _MockDirectory()..fieldListSync = [File(testName)];

      final tested = generator.testFiles(mockDir, testName);

      expect(tested, isEmpty);
    });
  });

  group('generateTestFile', () {
    late TestGenerator generator;
    late File aggregatedFile;
    late _MockDirectory mockDir;
    setUp(() {
      generator = TestGenerator();
      aggregatedFile = MemoryFileSystem().file('test.dart');
      mockDir = _MockDirectory()..fieldListSync = [File('my_test.dart')];
      when(mockDir.path).thenReturn('/');
    });

    test('writes aggregated test file with args', () async {
      const content = '''
// ignore_for_file: directives_ordering
/// This file is autogenerated and should not be committed to source control

import 'my_test.dart' as my;

void main(List<String> args) {
  my.main(args);
}
''';

      await generator.generateTestFile(aggregatedFile, mockDir, '',
          hasArguments: true);

      expect(aggregatedFile.readAsStringSync(), content);
    });

    test('writes aggregated test file without args', () async {
      const content = '''
// ignore_for_file: directives_ordering
/// This file is autogenerated and should not be committed to source control

import 'my_test.dart' as my;

void main() {
  my.main();
}
''';

      await generator.generateTestFile(aggregatedFile, mockDir, '',
          hasArguments: false);

      expect(aggregatedFile.readAsStringSync(), content);
    });

    test('tests are sorted by name', () async {
      mockDir.fieldListSync = [
        File('b_test.dart'),
        File('a_test.dart'),
      ];

      const content = '''
// ignore_for_file: directives_ordering
/// This file is autogenerated and should not be committed to source control

import 'b_test.dart' as b;
import 'a_test.dart' as a;

void main(List<String> args) {
  a.main(args);
  b.main(args);
}
''';

      await generator.generateTestFile(aggregatedFile, mockDir, '',
          hasArguments: true);

      expect(aggregatedFile.readAsStringSync(), content);
    });
  });

  group('aggregatedTest', () {
    late MockTestGenerator generator;
    setUp(() {
      generator = MockTestGenerator();
    });
    test('generates test file', () {
      IOOverrides.runZoned(
        () async {
          final logger = MockLogger();
          expect(await aggregatedTest('/', generator, logger), setupMainFile);
        },
        createDirectory: (name) {
          const absolutePath =
              r'c:\Users\tpolanski\Documents\GitHub\flutter-project';
          final file = _MockFile()..pathMock = '$name$setupMainFile';
          final absoluteDir = _MockDirectory();
          when(absoluteDir.path).thenReturn('$absolutePath\\$name');
          final mockDir = _MockDirectory();
          when(mockDir.path).thenReturn(name);
          mockDir.fieldListSync = [file];
          when(mockDir.absolute).thenReturn(absoluteDir);
          return mockDir;
        },
        createFile: (name) => MemoryFileSystem().file(setupMainFile),
      );
    });

    test('generate properly paths for not root folders', () {
      final absolutePath = Platform.isWindows
          ? r'c:\Users\tpolanski\Documents\GitHub\flutter-project'
          : '/Users/tpolanski/Documents/GitHub/flutter-project';
      IOOverrides.runZoned(
        () async {
          final logger = MockLogger();

          await aggregatedTest(
              r'test_driver\deals\edits'.toPlatformPath, generator, logger);
          expect(
            verify(generator.generateTestFile(any, any, captureAny,
                    hasArguments: anyNamed('hasArguments')))
                .captured
                .single,
            '../deals/edits/',
          );
        },
        createDirectory: (name) {
          final file = _MockFile()
            ..pathMock =
                '$absolutePath/test_driver/generic/generic.dart'.toPlatformPath;
          final absoluteDir = _MockDirectory();
          when(absoluteDir.path)
              .thenReturn('$absolutePath/$name'.toPlatformPath);
          final mockDir = _MockDirectory();
          when(mockDir.path).thenReturn(name);
          mockDir.fieldListSync = [file];
          when(mockDir.absolute).thenReturn(absoluteDir);
          return mockDir;
        },
        createFile: (name) {
          if (name.endsWith(aggregatedTestFile)) {
            final absolute = _MockFile()..pathMock = name;
            return _MockFile()
              ..fieldExistsSync = true
              ..pathMock = name
              ..absoluteMock = absolute;
          }
          return MemoryFileSystem().file('$absolutePath\\$setupMainFile');
        },
      );
    });

    test('invalid dir separator', () {
      final absolutePath = Platform.isWindows
          ? r'c:\Users\tpolanski\Documents\GitHub\flutter-project'
          : '/Users/tpolanski/Documents/GitHub/flutter-project';
      IOOverrides.runZoned(
        () async {
          final logger = MockLogger();

          await aggregatedTest(
              'test_driver/redemption'.toPlatformPath, generator, logger);
          expect(
            verify(generator.generateTestFile(
              any,
              any,
              captureAny,
              hasArguments: anyNamed('hasArguments'),
            )).captured.single,
            '../redemption/',
          );
        },
        createDirectory: (name) {
          final file = _MockFile()
            ..pathMock =
                '$absolutePath/test_driver/generic/generic.dart'.toPlatformPath;
          final absoluteDir = _MockDirectory();
          when(absoluteDir.path).thenReturn('$absolutePath/$name'
              .toPlatformPath
              .replaceAll(r'\redemption', '/redemption'));
          final mockDir = _MockDirectory();
          when(mockDir.path).thenReturn(name);
          mockDir.fieldListSync = [file];
          when(mockDir.absolute).thenReturn(absoluteDir);
          return mockDir;
        },
        createFile: (name) {
          if (name.endsWith(aggregatedTestFile)) {
            final absolute = _MockFile()..pathMock = name;
            final file = _MockFile()
              ..pathMock = name
              ..fieldExistsSync = true
              ..absoluteMock = absolute;
            return file;
          }
          return MemoryFileSystem().file('$absolutePath\\$setupMainFile');
        },
      );
    });

    test('generate properly paths for root folder', () {
      final absolutePath = Platform.isWindows
          ? r'c:\Users\tpolanski\Documents\GitHub\flutter-project'
          : '/Users/tpolanski/Documents/GitHub/flutter-project';
      IOOverrides.runZoned(
        () async {
          final logger = MockLogger();

          await aggregatedTest('test_driver', generator, logger);
          expect(
            verify(generator.generateTestFile(any, any, captureAny,
                    hasArguments: anyNamed('hasArguments')))
                .captured
                .single,
            '../',
          );
        },
        createDirectory: (name) {
          final file = _MockFile()
            ..pathMock =
                '$absolutePath/test_driver/generic/generic.dart'.toPlatformPath;
          final absoluteDir = _MockDirectory();
          when(absoluteDir.path)
              .thenReturn('$absolutePath/$name'.toPlatformPath);
          final mockDir = _MockDirectory();
          when(mockDir.path).thenReturn(name);
          mockDir.fieldListSync = [file];
          when(mockDir.absolute).thenReturn(absoluteDir);
          return mockDir;
        },
        createFile: (name) {
          if (name.endsWith(aggregatedTestFile)) {
            final absolute = _MockFile()..pathMock = name;
            final file = _MockFile()
              ..pathMock = name
              ..fieldExistsSync = true
              ..absoluteMock = absolute;

            return file;
          }
          return MemoryFileSystem()
              .file('$absolutePath/$setupMainFile'.toPlatformPath);
        },
      );
    });
  });

  group('TestFileProvider', () {
    late TestFileProvider tested;

    setUp(() {
      tested = TestFileProvider(logger: MockLogger());
    });

    test('when dir does not exist but file does', () async {
      await IOOverrides.runZoned(
        () async {
          const fileName = 'any.dart';

          final result = await tested.testFile(fileName);

          expect(result, fileName);
        },
        createDirectory: (name) {
          return _MockDirectory()..fieldExistsSync = false;
        },
        createFile: (name) {
          final file = _MockFile()
            ..fieldExistsSync = true
            ..pathMock = name;
          return file;
        },
      );
    });

    test('when neither file nor dir exist', () async {
      await IOOverrides.runZoned(
        () async {
          expect(await tested.testFile('none'), isNull);
        },
        createDirectory: (name) {
          return _MockDirectory()..fieldExistsSync = false;
        },
        createFile: (name) {
          final file = _MockFile()
            ..fieldExistsSync = false
            ..pathMock = name;
          return file;
        },
      );
    });
  });
}

class _MockDirectory extends MockDirectory {
  List<FileSystemEntity> fieldListSync = [];
  bool fieldExistsSync = false;

  @override
  bool existsSync() {
    return fieldExistsSync;
  }

  @override
  List<FileSystemEntity> listSync({bool? recursive, bool? followLinks}) {
    return fieldListSync;
  }

  @override
  String toString() {
    return '';
  }
}

class _MockFile extends NonMockitoFile {
  bool fieldExistsSync = false;

  @override
  bool existsSync() {
    return fieldExistsSync;
  }

  @override
  Future<FileSystemEntity> delete({bool recursive = false}) async {
    return _MockFile();
  }
}

extension on String {
  String get toPlatformPath =>
      Platform.isWindows ? replaceAll('/', r'\') : replaceAll(r'\', '/');
}
