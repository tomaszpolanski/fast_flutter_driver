import 'dart:io';

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
  group('remoteVersion', () {
    group('when yaml', () {
      test('reads yaml file', () async {
        await IOOverrides.runZoned(
          () async {
            final pathProvider = _MockPathProvider();
            when(pathProvider.scriptDir).thenReturn('/root/');
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
  });
}

class _MockFile extends Mock implements File {}

class _MockPathProvider extends Mock implements PathProvider {}
