import 'package:fast_flutter_driver_tool/src/update/version.dart';
import 'package:http/http.dart';
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
}
