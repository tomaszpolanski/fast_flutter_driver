import 'package:fast_flutter_driver/src/restart_widget.dart';
import 'package:fast_flutter_driver/src/window_utils/macos_window.dart';
import 'package:fast_flutter_driver/src/window_utils/unsupported_window.dart';
import 'package:fast_flutter_driver/src/window_utils/window_utils.dart';
import 'package:fast_flutter_driver/src/window_utils/windows/win32_window.dart';
import 'package:fast_flutter_driver_tool/fast_flutter_driver_tool.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';

Future<void> configureTest(BaseConfiguration config) async {
  await WindowUtils(
    macOs: () => MacOsWindow(),
    win32: () => Win32Window(),
    other: () => UnsupportedWindow(),
  ).setSize(
    Size(config.resolution.width, config.resolution.height),
  );

  final platform = config.platform?.targetPlatform;
  if (platform != null && debugDefaultTargetPlatformOverride != platform) {
    debugDefaultTargetPlatformOverride = platform;
  }

  await RestartWidget.restartApp(config);
}

extension TestFlutterEx on TestPlatform {
  TargetPlatform get targetPlatform {
    switch (this) {
      case TestPlatform.android:
        return TargetPlatform.android;
      case TestPlatform.iOS:
        return TargetPlatform.iOS;
    }
  }
}
