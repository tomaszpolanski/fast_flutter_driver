import 'dart:io';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:meta/meta.dart';

const _dirPath = 'screenshots';

class Screenshot {
  Screenshot._(
    this._dir,
    this._driver, {
    @required bool enabled,
  }) : _enabled = enabled;

  final String _dir;
  final FlutterDriver _driver;
  final bool _enabled;

  static Future<Screenshot> create(
    FlutterDriver driver,
    String group, {
    bool enabled,
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
    await Future<void>.delayed(const Duration(milliseconds: 100));

    return FakeAsync().run((async) {
      final result = driver.screenshot();
      async.elapse(const Duration(minutes: 1));
      return result;
    });
  }
}
