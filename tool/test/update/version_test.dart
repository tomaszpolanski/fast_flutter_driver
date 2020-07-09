import 'dart:io';

import 'package:fast_flutter_driver_tool/src/update/path_provider_impl.dart';
import 'package:fast_flutter_driver_tool/src/update/version.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  VersionChecker tested;
  PathProvider pathProvider;

  setUp(() {
    pathProvider = _MockPathProvider();
  });

  group('remoteVersion', () {
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
      String requestUrl;
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
            '<h2 class="title">fast_flutter_driver_tool $expectedVersion</h2>',
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
          httpGet: (_) => null,
        );
        await IOOverrides.runZoned(
          () async {
            final version = await tested.currentVersion();

            expect(version, '1.0.0+1');
          },
          createFile: (name) {
            if (name == '/root/../pubspec.yaml') {
              final File file = _MockFile();
              when(file.existsSync()).thenReturn(true);
              when(file.readAsString())
                  .thenAnswer((_) async => 'version: 1.0.0+1');
              return file;
            }
            return null;
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
          httpGet: (_) => null,
        );
        await IOOverrides.runZoned(
          () async {
            final version = await tested.currentVersion();

            expect(version, '2.2.0');
          },
          createFile: (name) {
            if (name == '/root/../pubspec.lock') {
              final File file = _MockFile();
              when(file.existsSync()).thenReturn(true);
              when(file.readAsLines())
                  .thenAnswer((_) async => lockFileContent.split('\n'));
              return file;
            } else {
              final File file = _MockFile();
              when(file.existsSync()).thenReturn(false);
              return file;
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

    test('when available', () async {
      const remoteVersion = '2.0.0';
      const currentVersion = '1.0.0';
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

          expect(result.local, currentVersion);
          expect(result.remote, remoteVersion);
        },
        createFile: (name) {
          if (name == '/root/../pubspec.yaml') {
            final File file = _MockFile();
            when(file.existsSync()).thenReturn(true);
            when(file.readAsString())
                .thenAnswer((_) async => 'version: $currentVersion');
            return file;
          }
          return null;
        },
      );
    });

    test('when up to date', () async {
      const remoteVersion = '2.0.0';
      const currentVersion = '2.0.0';
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

          expect(result.local, currentVersion);
          expect(result.remote, remoteVersion);
        },
        createFile: (name) {
          if (name == '/root/../pubspec.yaml') {
            final File file = _MockFile();
            when(file.existsSync()).thenReturn(true);
            when(file.readAsString())
                .thenAnswer((_) async => 'version: $currentVersion');
            return file;
          }
          return null;
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
            final File file = _MockFile();
            when(file.existsSync()).thenReturn(true);
            when(file.readAsString())
                .thenAnswer((_) async => 'version: $currentVersion');
            return file;
          }
          return null;
        },
      );
    });
  });
}

class _MockFile extends Mock implements File {}

class _MockPathProvider extends Mock implements PathProvider {}
