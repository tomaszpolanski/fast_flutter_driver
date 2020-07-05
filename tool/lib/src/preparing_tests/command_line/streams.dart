import 'dart:async';
import 'dart:convert';

// ignore: one_member_abstracts
abstract class CommandLineStream {
  Future<void> dispose();
}

typedef OutputFactory = OutputCommandLineStream Function(
  void Function(String) onData,
);

OutputCommandLineStream output(void Function(String line) onData) {
  return OutputCommandLineStream._(onData);
}

class OutputCommandLineStream implements CommandLineStream {
  OutputCommandLineStream._(void Function(String line) onData) {
    _output.stream
        .transform(utf8.decoder)
        .listen((data) => onData(data.trim()));
  }

  final StreamController<List<int>> _output = StreamController();

  StreamSink<List<int>> get stream => _output;

  @override
  Future<void> dispose() => _output.close();
}

typedef InputFactory = InputCommandLineStream Function();

InputCommandLineStream input() {
  return InputCommandLineStream._();
}

class InputCommandLineStream implements CommandLineStream {
  InputCommandLineStream._();

  StreamController<String> input = StreamController();

  Stream<List<int>> get stream => input.stream.map(utf8.encode);

  void write(String line) => input.add(line);

  @override
  Future<void> dispose() => input.close();
}
