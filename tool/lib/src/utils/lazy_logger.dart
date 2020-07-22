import 'package:cli_util/cli_logging.dart';

class LazyLogger implements Logger {
  LazyLogger(this._loggerFactory);

  final Logger Function(bool verbose) _loggerFactory;

  bool verbose = false;

  Logger _instance;

  Logger get _logger => _instance ??= _loggerFactory(verbose);

  @override
  Ansi get ansi => _logger.ansi;

  @override
  // ignore: deprecated_member_use
  void flush() => _logger.flush();

  @override
  bool get isVerbose => _logger.isVerbose;

  @override
  Progress progress(String message) => _logger.progress(message);

  @override
  void stderr(String message) => _logger.stderr(message);

  @override
  void stdout(String message) => _logger.stdout(message);

  @override
  void trace(String message) => _logger.trace(message);

  @override
  void write(String message) => _logger.write(message);

  @override
  void writeCharCode(int charCode) => _logger.writeCharCode(charCode);
}
