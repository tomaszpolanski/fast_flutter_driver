import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/utils/lazy_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'lazy_logger_test.mocks.dart';

@GenerateMocks([Logger, Progress])
void main() {
  late LazyLogger tested;

  MockLogger createLogger() {
    final logger = MockLogger();
    when(logger.trace(any)).thenAnswer((_) {});
    when(logger.stdout(any)).thenAnswer((_) {});
    when(logger.stderr(any)).thenAnswer((_) {});
    when(logger.write(any)).thenAnswer((_) {});
    when(logger.writeCharCode(any)).thenAnswer((_) {});
    when(logger.flush()).thenAnswer((_) {});
    when(logger.ansi).thenAnswer((_) => Ansi(false));
    when(logger.isVerbose).thenAnswer((_) => false);
    when(logger.progress(any)).thenReturn(MockProgress());
    return logger;
  }

  test('creates logger when calling for the first time', () {
    var factoryWasCalled = false;
    tested = LazyLogger((_) {
      factoryWasCalled = true;

      return createLogger();
    })
      ..flush();

    expect(factoryWasCalled, isTrue);
  });

  test('factory is not called if any method is not called', () {
    var factoryWasCalled = false;
    tested = LazyLogger((_) {
      factoryWasCalled = true;

      return createLogger();
    });

    expect(factoryWasCalled, isFalse);
  });

  group('verbosity', () {
    test('by default logger is created not verbose', () {
      late bool isVerbose;
      tested = LazyLogger((verbose) {
        isVerbose = verbose;

        return createLogger();
      })
        ..flush();

      expect(isVerbose, isFalse);
    });

    test('verbose property changes logger to be verbose', () {
      late bool isVerbose;
      tested = LazyLogger((verbose) {
        isVerbose = verbose;

        final logger = createLogger();
        when(logger.isVerbose).thenReturn(isVerbose);
        return logger;
      })
        ..isVerbose = true
        ..flush();

      expect(isVerbose, isTrue);
      expect(tested.isVerbose, isTrue);
    });
  });

  group('invokes methods', () {
    late MockLogger logger;
    setUp(() {
      logger = createLogger();
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
