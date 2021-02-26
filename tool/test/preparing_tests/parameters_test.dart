import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'parameters_test.mocks.dart';

@GenerateMocks([Logger])
void main() {
  MockLogger createLogger() {
    final logger = MockLogger();
    when(logger.trace(any)).thenAnswer((_) {});
    when(logger.stdout(any)).thenAnswer((_) {});
    when(logger.stderr(any)).thenAnswer((_) {});
    when(logger.write(any)).thenAnswer((_) {});
    when(logger.writeCharCode(any)).thenAnswer((_) {});
    when(logger.ansi).thenAnswer((_) => Ansi(false));
    when(logger.isVerbose).thenAnswer((_) => false);
    return logger;
  }

  group('printErrorHelp', () {
    test('writes help message', () {
      final logger = createLogger();
      const command = 'some_command';

      printErrorHelp(command, logger: logger);

      expect(
        verify(logger.stdout(captureAny)).captured.single,
        "\x1B[91mFailed\x1B[0m to run command '\x1B[93m$command\x1B[0m'\n"
        'To \x1B[92mfix\x1B[0m it:\n'
        '  • Close already running application\n'
        '  • Clean workspace by running:\n'
        '    \x1B[92mflutter clean\x1B[0m\n'
        '  • Enable desktop by running: \n'
        '    \x1B[92mflutter config --enable-linux-desktop --enable-macos-desktop --enable-windows-desktop\x1B[0m\n'
        '  • Run the tests again in verbose mode:\n'
        '    \x1B[92msome_command -v\x1B[0m',
      );
    });
  });
}
