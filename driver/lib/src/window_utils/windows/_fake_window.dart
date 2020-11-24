import 'dart:async';

import 'package:fast_flutter_driver/src/window_utils/window_utils.dart';
import 'package:flutter/material.dart';

class Win32Window implements SystemWindow {
  @override
  Future<bool> setSize(Size size) {
    return Future.value(false);
  }
}
