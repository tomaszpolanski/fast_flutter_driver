// coverage:ignore-file

import 'dart:async';

import 'package:fast_flutter_driver_tool/fast_flutter_driver_tool.dart';
import 'package:flutter/material.dart';

// ignore: one_member_abstracts
abstract class SystemWindow {
  Future<bool> setSize(Size size);
}

typedef WindowFactory = SystemWindow Function();

// ignore: avoid_classes_with_only_static_members
class WindowUtils implements SystemWindow {
  WindowUtils({
    required this.macOs,
    required this.win32,
    required this.other,
  }) : _systemWindow = System.isMacOS
            ? macOs()
            : System.isWindows
                ? win32()
                : other();

  final WindowFactory macOs;
  final WindowFactory win32;
  final WindowFactory other;

  final SystemWindow _systemWindow;

  @override
  Future<bool> setSize(Size size) => _systemWindow.setSize(size);
}
