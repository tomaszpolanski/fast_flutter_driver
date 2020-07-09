import 'package:fast_flutter_driver/src/window_utils/unsupported_window.dart';
import 'package:flutter/rendering.dart';
import 'package:test/test.dart';

void main() {
  test('not supported', () async {
    final tested = UnsupportedWindow();

    expect(await tested.setSize(const Size(0, 0)), isFalse);
  });
}
