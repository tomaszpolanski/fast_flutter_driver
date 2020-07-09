// coverage:ignore-file
// coverage:ignore-start
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line/streams.dart';
import 'package:meta/meta.dart';
import 'package:process_run/shell.dart';

typedef RunCommand = Future<void> Function(
  String command, {
  @required OutputCommandLineStream stdout,
  InputCommandLineStream stdin,
  OutputCommandLineStream stderr,
});

Future<void> run(
  String command, {
  @required OutputCommandLineStream stdout,
  InputCommandLineStream stdin,
  OutputCommandLineStream stderr,
}) async {
  return _CommandLine(
    stdout: stdout,
    stdin: stdin,
    stderr: stderr,
  ).run(command);
}

class _CommandLine {
  _CommandLine({
    @required this.stdout,
    this.stdin,
    this.stderr,
  }) : _shell = Shell(
          stdout: stdout.stream,
          stdin: stdin?.stream,
          stderr: stderr?.stream,
        );

  final Shell _shell;
  final InputCommandLineStream stdin;
  final OutputCommandLineStream stdout;
  final OutputCommandLineStream stderr;

  Future<void> run(String command) async {
    await _shell.run(command);
  }
}
