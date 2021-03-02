import 'dart:convert';

import 'package:example/app.dart';
import 'package:fast_flutter_driver/driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'test_configuration.dart';

void main() {
  timeDilation = 0.1;
  enableFlutterDriverExtension(
    handler: (playload) async {
      await configureTest(
        TestConfiguration.fromJson(json.decode(playload ?? '{}')),
      );
      return '';
    },
  );

  runApp(
    RestartWidget<TestConfiguration>(
      backgroundColor: Colors.red,
      builder: (_, config) => ExampleApp(route: config.route),
    ),
  );
}
