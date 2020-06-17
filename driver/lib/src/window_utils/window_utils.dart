import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:win32/win32.dart';

class WindowUtils {
  static const MethodChannel _channel = MethodChannel('window_utils');

  static Future<bool> showTitleBar() {
    return _channel.invokeMethod<bool>('showTitleBar');
  }

  static Future<bool> hideTitleBar() {
    return _channel.invokeMethod<bool>('hideTitleBar');
  }

  static Future<bool> closeWindow() {
    return _channel.invokeMethod<bool>('closeWindow');
  }

  static Future<bool> centerWindow() {
    return _channel.invokeMethod<bool>('centerWindow');
  }

  static Future<bool> setPosition(Offset offset) {
    return _channel.invokeMethod<bool>('setPosition', {
      'x': offset.dx,
      'y': offset.dy,
    });
  }

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

  static Future<bool> startDrag() {
    return _channel.invokeMethod<bool>('startDrag');
  }

  static Future<bool> windowTitleDoubleTap() {
    return _channel.invokeMethod<bool>('windowTitleDoubleTap');
  }

  static Future<int> childWindowsCount() {
    return _channel.invokeMethod<int>('childWindowsCount');
  }

  /// Size of Screen that the current window is inside
  static Future<Size> getScreenSize() async {
    final _data =
        await _channel.invokeMethod<Map<String, dynamic>>('getScreenSize');
    return Size(_data['width'], _data['height']);
  }

  static Future<Size> getWindowSize() async {
    final _data =
        await _channel.invokeMethod<Map<String, dynamic>>('getWindowSize');
    return Size(_data['width'], _data['height']);
  }

  static Future<Offset> getWindowOffset() async {
    final _data =
        await _channel.invokeMethod<Map<String, dynamic>>('getWindowOffset');
    return Offset(_data['offsetX'], _data['offsetY']);
  }

  static Future<bool> hideCursor() {
    return _channel.invokeMethod<bool>('hideCursor');
  }

  static Future<bool> showCursor() {
    return _channel.invokeMethod<bool>('showCursor');
  }

  static Future<bool> setCursor(CursorType cursor) {
    return _channel.invokeMethod<bool>(
      'setCursor',
      {
        'type': describeEnum(cursor),
        'update': false,
      },
    );
  }

  static Future<bool> addCursorToStack(CursorType cursor) {
    return _channel.invokeMethod<bool>(
      'setCursor',
      {
        'type': describeEnum(cursor),
        'update': true,
      },
    );
  }

  static Future<bool> removeCursorFromStack() {
    return _channel.invokeMethod<bool>('removeCursorFromStack');
  }

  static Future<int> mouseStackCount() {
    return _channel.invokeMethod<int>('mouseStackCount');
  }

  static Future<bool> resetCursor() {
    return _channel.invokeMethod<bool>('resetCursor');
  }
}

enum CursorType {
  arrow,
  beamVertical,
  crossHair,
  closedHand,
  openHand,
  pointingHand,
  resizeLeft,
  resizeRight,
  resizeDown,
  resizeUp,
  resizeLeftRight,
  resizeUpDown,
  beamHorizontal,
  disappearingItem,
  notAllowed,
  dragLink,
  dragCopy,
  contextMenu,
}
