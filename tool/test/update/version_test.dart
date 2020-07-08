import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/update/path_provider.dart';
import 'package:fast_flutter_driver_tool/src/update/version.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group('remoteVersion', () {
    test('throws exception if version not found', () async {
      Future<Response> get(String url) async => Response('', 200);
      try {
        await remoteVersion(get);
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

      try {
        await remoteVersion(get);
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

      final version = await remoteVersion(get);

      expect(version, expectedVersion);
    });
  });

  group('currentVersion', () {
    _MockPathProvider pathProvider;
    setUp(() {
      pathProvider = _MockPathProvider();
      when(pathProvider.scriptDir).thenReturn('/root/');
    });
    group('when yaml', () {
      test('reads yaml file', () async {
        await IOOverrides.runZoned(
          () async {
            final version = await currentVersion(pathProvider);

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
        await IOOverrides.runZoned(
          () async {
            final version = await currentVersion(pathProvider);

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
    _MockPathProvider pathProvider;
    Logger logger;
    setUp(() {
      pathProvider = _MockPathProvider();
      when(pathProvider.scriptDir).thenReturn('/root/');
      logger = _MockLogger();
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
          await checkForUpdates(
            logger: logger,
            httpGet: get,
            pathProvider: pathProvider,
          );

          final messages = verify(logger.stdout(captureAny)).captured;
          expect(
            messages[0],
            '\x1B[92mNew version\x1B[0m (\x1B[1m$remoteVersion\x1B[0m) available!',
          );
          expect(
            messages[1],
            "To update, run \x1B[92m'pub global activate fast_flutter_driver_tool'\x1B[0m",
          );
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
          await checkForUpdates(
            logger: logger,
            httpGet: get,
            pathProvider: pathProvider,
          );

          verifyNever(logger.stdout(any));
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

class _MockLogger extends Mock implements Logger {}
