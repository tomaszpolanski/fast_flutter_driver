import 'dart:io';

import 'package:fast_flutter_driver/src/running_tests/app/restart_widget.dart';
import 'package:fast_flutter_driver/src/running_tests/test/parameters.dart';
import 'package:fast_flutter_driver/src/running_tests/test/tests.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:window_utils/window_utils.dart';

Future<String> configureTest(BaseConfiguration config) async {
  if (Platform.isMacOS) {
    await WindowUtils.setSize(
      Size(config.resolution.width, config.resolution.height),
    );
  }

  final platform = config.platform.targetPlatform;
  if (debugDefaultTargetPlatformOverride != platform) {
    debugDefaultTargetPlatformOverride = platform;
  }

  await RestartWidget.restartApp(config);
  return null;
}

extension TestFlutterEx on TestPlatform {
  TargetPlatform get targetPlatform {
    switch (this) {
      case TestPlatform.android:
        return TargetPlatform.android;
      case TestPlatform.iOS:
        return TargetPlatform.iOS;
      default:
        return TargetPlatform.fuchsia;
    }
  }
}
