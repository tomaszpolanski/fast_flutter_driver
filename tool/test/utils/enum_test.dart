import 'package:fast_flutter_driver_tool/src/utils/enum.dart';
import 'package:test/test.dart';

enum _TestEnum { test }

void main() {
  test('fromEnum', () {
    final tested = fromEnum(_TestEnum.test);

    expect(tested, 'test');
  });
}
