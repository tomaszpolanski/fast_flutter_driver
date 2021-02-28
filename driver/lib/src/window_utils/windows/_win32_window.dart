import 'dart:async';
import 'dart:ffi';

import 'package:fast_flutter_driver/src/window_utils/window_utils.dart';
import 'package:flutter/material.dart';
import 'package:win32/win32.dart';

class Win32Window implements SystemWindow {
  @override
  Future<bool> setSize(Size size) {
    final window =
        FindWindowEx(0, 0, TEXT('FLUTTER_RUNNER_WIN32_WINDOW'), nullptr);
    print('QQQ1 ${window}');
    if (window == 0) {
      throw Exception('Cannot find flutter window');
    } else {
      print('QQQ2');
      try {
        SetForegroundWindow(window);
      //  SetWindowPos(window, window, 0, 0, 100, 100, SWP_NOZORDER | SWP_NOACTIVATE);
      } catch (e) {
        print('QQQ!!!! $e');
      }

      //ShowWindow(window, SW_MAXIMIZE);
      print('QQQ3');
     // MoveWindow(window, 0, 0, size.width.round(), size.height.round(), FALSE);
      print('QQQ4');
      return Future.value(true);
    }
  }
}
