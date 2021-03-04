import 'dart:io';

import 'package:fast_flutter_driver_tool/src/update/path_provider_impl.dart';
import 'package:fast_flutter_driver_tool/src/update/version.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks/mock_file.dart';
import 'version_test.mocks.dart';

@GenerateMocks([
  PathProvider,
])
void main() {
  late VersionChecker tested;
  late MockPathProvider pathProvider;

  setUp(() {
    pathProvider = MockPathProvider();
  });

  group('remoteVersion', () {
    test('integration test', () async {
      tested = VersionChecker(
        pathProvider: pathProvider,
        httpGet: (url) => get(Uri.parse(url)),
      );

      final version = await tested.remoteVersion();

      expect(version, isNotNull);
    });

    test('throws exception if version not found', () async {
      Future<Response> get(String url) async => Response('', 200);
      tested = VersionChecker(
        pathProvider: pathProvider,
        httpGet: get,
      );
      try {
        await tested.remoteVersion();
      } on PackageNotFound {
        return;
      }

      fail('Did not throw the exception');
    });

    test('fetches data from the pub.dev', () async {
      late String requestUrl;
      Future<Response> get(String url) async {
        requestUrl = url;
        return Response('', 200);
      }

      tested = VersionChecker(
        pathProvider: pathProvider,
        httpGet: get,
      );
      try {
        await tested.remoteVersion();
      } on PackageNotFound {
        // ignore
      }

      expect(requestUrl, 'https://pub.dev/packages/fast_flutter_driver_tool');
    });

    test('looks up the package name in the html', () async {
      const expectedVersion = '1.0.0+1';
      Future<Response> get(String url) async => Response(
            '<span class="code">fast_flutter_driver_tool: ^$expectedVersion</span>',
            200,
          );
      tested = VersionChecker(
        pathProvider: pathProvider,
        httpGet: get,
      );

      final version = await tested.remoteVersion();

      expect(version, expectedVersion);
    });
  });

  group('currentVersion', () {
    setUp(() {
      when(pathProvider.scriptDir).thenReturn('/root/');
    });
    group('when yaml', () {
      test('reads yaml file', () async {
        tested = VersionChecker(
          pathProvider: pathProvider,
          httpGet: (_) async => Response('', 418),
        );
        await IOOverrides.runZoned(
          () async {
            final version = await tested.currentVersion();

            expect(version, '1.0.0+1');
          },
          createFile: (name) {
            if (name == '/root/../pubspec.yaml') {
              final File file = _MockFile()
                ..fieldExistsSync = true
                ..readAsStringMock = 'version: 1.0.0+1';
              return file;
            }
            throw Exception('No file');
          },
        );
      });
    });

    group('when lock', () {
      const lockFileContent = '''
  fast_flutter_driver_tool:
    dependency: transitive
    description:
      name: fast_flutter_driver_tool
      url: "https://pub.dartlang.org"
    source: hosted
    version: "2.2.0"
''';
      test('reads lock file', () async {
        tested = VersionChecker(
          pathProvider: pathProvider,
          httpGet: (_) async => Response('', 418),
        );
        await IOOverrides.runZoned(
          () async {
            final version = await tested.currentVersion();

            expect(version, '2.2.0');
          },
          createFile: (name) {
            if (name == '/root/../pubspec.lock') {
              final File file = _MockFile()
                ..fieldExistsSync = true
                ..readAsLinesMock = lockFileContent.split('\n');
              return file;
            } else {
              return _MockFile()..fieldExistsSync = false;
            }
          },
        );
      });
    });
  });

  group('checkForUpdates', () {
    setUp(() {
      when(pathProvider.scriptDir).thenReturn('/root/');
    });

    test('when yaml available', () async {
      const remoteVersion = '2.0.0';
      const currentVersion = '1.0.0';
      await IOOverrides.runZoned(
        () async {
          Future<Response> get(String url) async => Response(
                '<span class="code">fast_flutter_driver_tool: ^$remoteVersion</span>',
                200,
              );
          tested = VersionChecker(
            pathProvider: pathProvider,
            httpGet: get,
          );
          final result = await tested.checkForUpdates();

          expect(result?.local, currentVersion);
          expect(result?.remote, remoteVersion);
        },
        createFile: (name) {
          if (name == '/root/../pubspec.yaml') {
            final File file = _MockFile()..fieldExistsSync = true;
            when(file.readAsString())
                .thenAnswer((_) async => 'version: $currentVersion');
            return file;
          }
          throw Exception('No file');
        },
      );
    });
    test('when yaml available but no version', () async {
      const remoteVersion = '2.0.0';
      await IOOverrides.runZoned(
        () async {
          Future<Response> get(String url) async => Response(
                '<h2 class="title">fast_flutter_driver_tool $remoteVersion</h2>',
                200,
              );
          tested = VersionChecker(
            pathProvider: pathProvider,
            httpGet: get,
          );
          final result = await tested.checkForUpdates();

          expect(result, isNull);
        },
        createFile: (name) {
          if (name == '/root/../pubspec.yaml') {
            final File file = _MockFile()
              ..fieldExistsSync = true
              ..readAsStringMock = '';
            return file;
          }
          throw Exception('No file');
        },
      );
    });

    test('when up to date', () async {
      const remoteVersion = '2.0.0';
      const currentVersion = '2.0.0';
      await IOOverrides.runZoned(
        () async {
          Future<Response> get(String url) async => Response(
                '<span class="code">fast_flutter_driver_tool: ^$remoteVersion</span>',
                200,
              );
          tested = VersionChecker(
            pathProvider: pathProvider,
            httpGet: get,
          );

          final result = await tested.checkForUpdates();

          expect(result?.local, currentVersion);
          expect(result?.remote, remoteVersion);
        },
        createFile: (name) {
          if (name == '/root/../pubspec.yaml') {
            final File file = _MockFile()
              ..fieldExistsSync = true
              ..readAsStringMock = 'version: $currentVersion';
            return file;
          }
          throw Exception('No file');
        },
      );
    });

    test('when failed', () async {
      const currentVersion = '2.0.0';
      await IOOverrides.runZoned(
        () async {
          Future<Response> get(String url) async => Response('', 404);
          tested = VersionChecker(
            pathProvider: pathProvider,
            httpGet: get,
          );

          final result = await tested.checkForUpdates();

          expect(result, isNull);
        },
        createFile: (name) {
          if (name == '/root/../pubspec.yaml') {
            final File file = _MockFile()
              ..fieldExistsSync = true
              ..readAsStringMock = 'version: $currentVersion';
            return file;
          }
          throw Exception('No file');
        },
      );
    });
  });
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
