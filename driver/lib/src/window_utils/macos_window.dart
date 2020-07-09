import 'package:fast_flutter_driver/src/window_utils/window_utils.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class MacOsWindow implements SystemWindow {
  factory MacOsWindow() => _instance;
  const MacOsWindow._();

  static const MacOsWindow _instance = MacOsWindow._();

  static const MethodChannel _channel = MethodChannel('window_utils');

  @override
  Future<bool> setSize(Size size) {
    return _channel.invokeMethod<bool>('setSize', {
      'width': size.width,
      'height': size.height,
    });
  }
}
