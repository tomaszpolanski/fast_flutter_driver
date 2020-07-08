import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line/streams.dart';
import 'package:test/test.dart';

void main() {
  group('InputCommandLineStream', () {
    test('write', () {
      final tested = input()..write('0');

      tested.stream.listen(expectAsync1((List<int> action) {
        expect(action, [48]);
      }, count: 1));
    });

    test('dispose', () async {
      // ignore: unawaited_futures
      final tested = input()..dispose();

      expect(tested.input.isClosed, isTrue);
    });
  });
}
