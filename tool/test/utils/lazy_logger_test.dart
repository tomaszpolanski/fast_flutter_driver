import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/utils/lazy_logger.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  LazyLogger tested;

  test('creates logger when calling for the first time', () {
    var factoryWasCalled = false;
    tested = LazyLogger((_) {
      factoryWasCalled = true;

      return _MockLogger();
    })
      ..flush();

    expect(factoryWasCalled, isTrue);
  });

  test('factory is not called if any method is not called', () {
    var factoryWasCalled = false;
    tested = LazyLogger((_) {
      factoryWasCalled = true;

      return _MockLogger();
    });

    expect(factoryWasCalled, isFalse);
  });

  group('verbosity', () {
    test('by default logger is created not verbose', () {
      bool isVerbose;
      tested = LazyLogger((verbose) {
        isVerbose = verbose;

        return _MockLogger();
      })
        ..flush();

      expect(isVerbose, isFalse);
    });

    test('verbose property changes logger to be verbose', () {
      bool isVerbose;
      tested = LazyLogger((verbose) {
        isVerbose = verbose;

        return _MockLogger();
      })
        ..verbose = true
        ..flush();

      expect(isVerbose, isTrue);
      expect(tested.verbose, isTrue);
    });
  });

  group('invokes methods', () {
    _MockLogger logger;
    setUp(() {
      logger = _MockLogger();
      tested = LazyLogger((_) => logger);
    });

    test('flush', () {
      tested.flush();

      // ignore: deprecated_member_use
      verify(logger.flush()).called(1);
    });

    test('ansi', () {
      tested.ansi;

      verify(logger.ansi).called(1);
    });

    test('isVerbose', () {
      tested.isVerbose;

      verify(logger.isVerbose).called(1);
    });

    test('progress', () {
      tested.progress('');

      verify(logger.progress(any)).called(1);
    });

    test('stderr', () {
      tested.stderr('');

      verify(logger.stderr(any)).called(1);
    });

    test('stdout', () {
      tested.stdout('');

      verify(logger.stdout(any)).called(1);
    });

    test('trace', () {
      tested.trace('');

      verify(logger.trace(any)).called(1);
    });

    test('write', () {
      tested.write('');

      verify(logger.write(any)).called(1);
    });

    test('writeCharCode', () {
      tested.writeCharCode(1);

      verify(logger.writeCharCode(any)).called(1);
    });
  });
}

class _MockLogger extends Mock implements Logger {}
