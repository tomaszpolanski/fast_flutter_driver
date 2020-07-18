import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/logger_extensions.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  late Logger logger;

  setUp(() {
    logger = _MockLogger();
  });

  group('printErrorHelp', () {
    test('blacklist', () {
      when(logger.isVerbose).thenReturn(false);
      const blacklisted = 'something blacklisted';
      logger.printTestError(blacklisted, [blacklisted]);

      verifyNever(logger.stderr(any));
      verifyNever(logger.trace(any));
    });

    test('blacklist still trace in verbose', () {
      when(logger.isVerbose).thenReturn(true);
      const blacklisted = 'something blacklisted';
      logger.printTestError(blacklisted, [blacklisted]);

      expect(verify(logger.trace(captureAny)).captured.single, blacklisted);
    });

    test('prints not blacklisted', () {
      when(logger.isVerbose).thenReturn(false);
      const line = 'valid';
      logger.printTestError(line, ['any']);

      expect(verify(logger.stderr(captureAny)).captured.single, line);
    });
  });

  group('printTestOutput', () {
    test('blacklist', () {
      when(logger.isVerbose).thenReturn(false);
      const blacklisted = 'something blacklisted';
      logger.printTestOutput(blacklisted, [blacklisted]);

      verifyNever(logger.stdout(any));
      verifyNever(logger.trace(any));
    });

    test('blacklist still trace in verbose', () {
      when(logger.isVerbose).thenReturn(true);
      const blacklisted = 'something blacklisted';
      logger.printTestOutput(blacklisted, [blacklisted]);

      expect(verify(logger.trace(captureAny)).captured.single, blacklisted);
    });

    test('prints not blacklisted', () {
      when(logger.isVerbose).thenReturn(false);
      const line = 'valid';
      logger.printTestOutput(line, ['any']);

      expect(verify(logger.stdout(captureAny)).captured.single, line);
    });
  });
}

class _MockLogger extends Mock implements Logger {}
