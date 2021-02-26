import 'package:fast_flutter_driver/src/window_utils/window_utils.dart';
import 'package:fast_flutter_driver_tool/fast_flutter_driver_tool.dart';
import 'package:flutter/rendering.dart';
import 'package:test/test.dart';

void main() {
  group('setSize', () {
    late _MockSystemWindow systemWindow;
    const size = Size(1, 1);
    setUp(() {
      systemWindow = _MockSystemWindow();
    });
    tearDown(() {
      macOsOverride = null;
      windowsOverride = null;
    });

    test('macOs', () async {
      macOsOverride = true;
      windowsOverride = false;
      linuxOverride = false;
      final tested = WindowUtils(
        macOs: () => systemWindow,
        win32: () => _MockSystemWindow(),
        other: () => _MockSystemWindow(),
      );

      await tested.setSize(size);

      expect(systemWindow.size, size);
    });

    test('windows', () async {
      macOsOverride = false;
      windowsOverride = true;
      linuxOverride = false;
      final tested = WindowUtils(
        macOs: () => _MockSystemWindow(),
        win32: () => systemWindow,
        other: () => _MockSystemWindow(),
      );

      await tested.setSize(size);

      expect(systemWindow.size, size);
    });

    test('other', () async {
      macOsOverride = false;
      windowsOverride = false;
      linuxOverride = true;
      final tested = WindowUtils(
        macOs: () => _MockSystemWindow(),
        win32: () => _MockSystemWindow(),
        other: () => systemWindow,
      );

      await tested.setSize(size);

      expect(systemWindow.size, size);
    });
  });
}

class _MockSystemWindow implements SystemWindow {
  Size? size;

  @override
  Future<bool> setSize(Size size) async {
    this.size = size;
    return false;
  }
}
