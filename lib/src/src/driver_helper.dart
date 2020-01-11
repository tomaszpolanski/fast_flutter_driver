import 'dart:io';

import 'package:fast_flutter_driver/src/shared/restart_widget.dart';
import 'package:fast_flutter_driver/src/src/tests.dart';
import 'package:flutter/material.dart';
import 'package:window_utils/window_utils.dart';

Future<String> configureTest(BaseConfiguration config) async {
  if (Platform.isMacOS) {
    await WindowUtils.setSize(
      Size(config.resolution.width, config.resolution.height),
    );
  }

//  final platform = config.platform.targetPlatform;
//  if (debugDefaultTargetPlatformOverride != platform) {
//    debugDefaultTargetPlatformOverride = platform;
//  }

  await RestartWidget.restartApp(config);
  return null;
}
