import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';

const _dirPath = 'screenshots';

class Screenshot {
  Screenshot._(
    this._dir,
    this._driver, {
    required bool enabled,
  }) : _enabled = enabled;

  final String _dir;
  final FlutterDriver _driver;
  final bool _enabled;

  static Future<Screenshot> create(
    FlutterDriver driver,
    String group, {
    required bool enabled,
  }) async {
    final ss = Screenshot._(
      '$_dirPath/$group',
      driver,
      enabled: enabled,
    );
    if (ss._enabled) {
      await ss._setupScreenshots();
    }
    return ss;
  }

  Future<void> takeScreenshot(String name) async {
    if (_enabled) {
      final List<int> pixels = await _fastScreenshot(_driver);
      final File file = File('$_dir/$name.png');
      await file.writeAsBytes(pixels);
    }
  }

  Future<Directory> _setupScreenshots() =>
      Directory(_dir).create(recursive: true);

  Future<List<int>> _fastScreenshot(FlutterDriver driver) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final result = await driver.serviceClient.callMethod('_flutter.screenshot');
    return const Base64Codec().decode(result.json!['screenshot']);
  }
}
