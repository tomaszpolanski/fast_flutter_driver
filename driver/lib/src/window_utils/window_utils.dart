// coverage:ignore-file
import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:win32/win32.dart';

class WindowUtils {
  static const MethodChannel _channel = MethodChannel('window_utils');

  static Future<bool> setSize(Size size) {
    if (Platform.isMacOS) {
      return _channel.invokeMethod<bool>('setSize', {
        'width': size.width,
        'height': size.height,
      });
    } else if (Platform.isWindows) {
      final window =
          FindWindowEx(0, 0, TEXT('FLUTTER_RUNNER_WIN32_WINDOW'), nullptr);

      if (window == 0) {
        throw Exception('Cannot find flutter window');
      } else {
        ShowWindow(window, SW_MAXIMIZE);
        MoveWindow(window, 0, 0, size.width.round(), size.height.round(), 0);
        return Future.value(true);
      }
    }
    return Future.value(false);
  }
}
