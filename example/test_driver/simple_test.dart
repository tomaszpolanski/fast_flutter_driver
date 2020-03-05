import 'dart:convert';

import 'package:driver_extensions/driver_extensions.dart';
import 'package:example/routes.dart' as routes;
import 'package:fast_flutter_driver/tool.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'generic/test_configuration.dart';

/// Every file that ends with '_text.dart' that is located in 'test_driver'
/// folder will be run in separation.
void main(List<String> args) {
  FlutterDriver driver;
  final properties = TestProperties(args);

  setUpAll(() async {
    driver = await FlutterDriver.connect(
      dartVmServiceUrl: properties.vmUrl,
    );
  });

  tearDownAll(() async {
    await driver?.close();
  });

  /// This method sends restart signal and configuration to the application.
  /// It does not have to be implemented per file. Move it to a separate file
  /// and reuse it.
  Future<void> restart(String route) {
    return driver.requestData(
      json.encode(
        TestConfiguration(
          resolution: properties.resolution,
          platform: properties.platform,
          route: route,
        ),
      ),
    );
  }

  group('Set of simple tests', () {
    test('- checking text on first page', () async {
      await restart(routes.page1);

      await driver.waitFor(find.text('/page1'));
    });

    test('- checking text on second page', () async {
      await restart(routes.page2);

      await driver.waitFor(find.text('/page2'));
    });
  });

  group('using setup to restart every test', () {
    setUp(() async {
      await restart(routes.page1);
    });

    test('- checking text', () async {
      await driver.waitFor(find.text('/page1'));
    });

    test('- checking type', () async {
      await driver.waitFor(find.byType('Page1'));
    });
  });

  /// You can use [driver_extensions](https://pub.dev/packages/driver_extensions)
  /// for better failure messages
  test('using driver_extensions', () async {
    await driver.waitForElement(find.byType('Page1'));
  });
}
