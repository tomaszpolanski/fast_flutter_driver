import 'package:fast_flutter_driver_tool/src/utils/colorizing.dart';
import 'package:test/test.dart';

void main() {
  const text = 'Some text';
  test('green', () {
    expect(green(text).toString(), '\x1B[92m$text\x1B[0m');
  });

  test('yellow', () {
    expect(yellow(text).toString(), '\x1B[93m$text\x1B[0m');
  });

  test('red', () {
    expect(red(text).toString(), '\x1B[91m$text\x1B[0m');
  });

  test('bold', () {
    expect(bold(text).toString(), '\x1B[1m$text\x1B[0m');
  });
}
