import 'package:cli_util/cli_logging.dart';

extension LoggerEx on Logger {
  void printTestError(String line, List<String> blackListed) {
    _print(line, blackListed, stderr);
  }

  void printTestOutput(String line, List<String> blackListed) {
    _print(line, blackListed, stdout);
  }

  void _print(
    String line,
    List<String> blackListed,
    void Function(String) print,
  ) {
    if (isVerbose) {
      trace(line);
    } else {
      if (line.isEmpty || blackListed.any(line.startsWith)) {
        return;
      }
      print(line);
    }
  }
}
