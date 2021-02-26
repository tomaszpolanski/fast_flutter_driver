import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/logger_extensions.dart';
import 'package:test/test.dart';

void main() {
  late _MockLogger logger;

  setUp(() {
    logger = _MockLogger();
  });

  group('printErrorHelp', () {
    test('blacklist', () {
      logger.isVerbose = false;
      const blacklisted = 'something blacklisted';
      logger.printTestError(blacklisted, [blacklisted]);

      expect(logger.stderrMock, isEmpty);
      expect(logger.traceMock, isEmpty);
    });

    test('blacklist still trace in verbose', () {
      logger.isVerbose = true;
      const blacklisted = 'something blacklisted';
      logger.printTestError(blacklisted, [blacklisted]);

      expect(logger.traceMock.single, blacklisted);
    });

    test('prints not blacklisted', () {
      logger.isVerbose = false;
      const line = 'valid';
      logger.printTestError(line, ['any']);

      expect(logger.stderrMock.single, line);
    });
  });

  group('printTestOutput', () {
    test('blacklist', () {
      logger.isVerbose = false;
      const blacklisted = 'something blacklisted';
      logger.printTestOutput(blacklisted, [blacklisted]);

      expect(logger.stdoutMock, isEmpty);
      expect(logger.traceMock, isEmpty);
    });

    test('blacklist still trace in verbose', () {
      logger.isVerbose = true;
      const blacklisted = 'something blacklisted';
      logger.printTestOutput(blacklisted, [blacklisted]);

      expect(logger.traceMock.single, blacklisted);
    });

    test('prints not blacklisted', () {
      logger.isVerbose = false;
      const line = 'valid';
      logger.printTestOutput(line, ['any']);

      expect(logger.stdoutMock.single, line);
    });
  });
}

class _MockLogger implements Logger {
  @override
  Ansi get ansi => throw UnimplementedError();

  @override
  void flush() {}

  @override
  bool isVerbose = false;

  final progressMock = <String>[];

  @override
  Progress progress(String message) {
    progressMock.add(message);
    return MockProgress(message);
  }

  final stderrMock = <String>[];

  @override
  void stderr(String message) => stderrMock.add(message);

  final stdoutMock = <String>[];

  @override
  void stdout(String message) => stdoutMock.add(message);

  final traceMock = <String>[];

  @override
  void trace(String message) => traceMock.add(message);

  final writeMock = <String>[];

  @override
  void write(String message) => writeMock.add(message);

  @override
  void writeCharCode(int charCode) {}
}

class MockProgress extends Progress {
  MockProgress(String message) : super(message);

  @override
  void cancel() {}

  @override
  void finish({String? message, bool showTiming = false}) {}
}
