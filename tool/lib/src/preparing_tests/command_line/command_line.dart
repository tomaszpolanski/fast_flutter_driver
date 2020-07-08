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
  return _CommandLine(out: stdout, sin: stdin, err: stderr).run(command);
}

class _CommandLine {
  _CommandLine({
    @required this.out,
    this.sin,
    this.err,
  }) : _s = Shell(stdout: out.stream, stdin: sin?.stream, stderr: err?.stream);

  final Shell _s;
  final InputCommandLineStream sin;
  final OutputCommandLineStream out;
  final OutputCommandLineStream err;

  Future<void> run(String command) => _s.run(command);
}
