import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line_stream.dart';
import 'package:meta/meta.dart';
import 'package:process_run/shell.dart';

class CommandLine {
  CommandLine({
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
