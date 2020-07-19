import 'package:fast_flutter_driver/src/window_utils/window_utils.dart';
import 'package:fast_flutter_driver_tool/fast_flutter_driver_tool.dart';
import 'package:flutter/rendering.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mockito_nnbd.dart' as nnbd_mockito;

void main() {
  group('setSize', () {
    late SystemWindow systemWindow;
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

      expect(
          verify(systemWindow.setSize(nnbd_mockito.captureAny)).captured.single,
          size);
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

      expect(
          verify(systemWindow.setSize(nnbd_mockito.captureAny)).captured.single,
          size);
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

      expect(
          verify(systemWindow.setSize(nnbd_mockito.captureAny)).captured.single,
          size);
    });
  });
}

class _MockSystemWindow extends Mock implements SystemWindow {}
