import 'package:fast_flutter_driver/src/src/parameters.dart';
import 'package:flutter/widgets.dart';

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
