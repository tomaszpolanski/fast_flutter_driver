// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:convert';

import 'package:example/routes.dart' as routes;
import 'package:fast_flutter_driver/tool.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'generic/test_configuration.dart';

void main(List<String> args) {
  FlutterDriver driver;
  final properties = TestProperties(args);

  setUpAll(() async {
    driver = await FlutterDriver.connect(dartVmServiceUrl: properties.vmUrl);
  });

  tearDownAll(() async {
    await driver?.close();
  });

  Future<void> restart(String route) {
    return driver.requestData(
      json.encode(
        TestConfiguration(
          resolution: properties.resolution,
          route: route,
        ),
      ),
    );
  }

  group('Route navigation', () {
    [
      routes.page1,
      routes.page2,
      routes.page3,
      routes.page4,
    ].forEach((route) {
      test(route, () async {
        await restart(route);

        await driver.waitFor(find.text(route));
      });
    });
  });

  group('Speed test', () {
    List.generate(100, (index) => '/generated_page_$index').forEach((route) {
      test(route, () async {
        await restart(route);

        await driver.waitFor(find.text(route));
      });
    });
  });
}
