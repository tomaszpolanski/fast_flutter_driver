import 'dart:async';
import 'dart:convert';

// ignore: one_member_abstracts
abstract class CommandLineStream {
  Future<void> dispose();
}

class OutputCommandLineStream implements CommandLineStream {
  OutputCommandLineStream(void Function(String line) onData) {
    output.stream.transform(utf8.decoder).listen((data) => onData(data.trim()));
  }

  StreamController<List<int>> output = StreamController();

  StreamSink<List<int>> get stream => output;

  @override
  Future<void> dispose() => output.close();
}

class InputCommandLineStream implements CommandLineStream {
  StreamController<String> input = StreamController();

  Stream<List<int>> get stream => input.stream.map(utf8.encode);

  void write(String line) => input.add(line);

  @override
  Future<void> dispose() => input.close();
}
