import 'dart:convert';

import 'package:example/routes.dart' as routes;
import 'package:fast_flutter_driver/tool.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../generic/test_configuration.dart';

/// Every file that ends with '_text.dart' that is located in 'test_driver'
/// folder will be run in separation.
void main(List<String> args) {
  late FlutterDriver driver;
  final properties = TestProperties(args);

  setUpAll(() async {
    driver = await FlutterDriver.connect(
      dartVmServiceUrl: properties.vmUrl,
    );
  });

  tearDownAll(() async {
    await driver.close();
  });

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

  test('subdir test', () async {
    await restart(routes.page1);

    await driver.waitFor(find.text('/page1'));
  });
}
