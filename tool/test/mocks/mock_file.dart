import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class NonMockitoFile implements File {
  late File absoluteMock;

  @override
  File get absolute => absoluteMock;

  late File copyMock;

  @override
  Future<File> copy(String newPath) async => copyMock;

  late File copySyncMock;

  @override
  File copySync(String newPath) => copySyncMock;

  late File createMock;

  @override
  Future<File> create({bool recursive = false}) async => copyMock;

  @override
  void createSync({bool recursive = false}) {}

  late FileSystemEntity deleteMock;

  @override
  Future<FileSystemEntity> delete({bool recursive = false}) async => deleteMock;

  @override
  void deleteSync({bool recursive = false}) {}

  bool existsMock = true;

  @override
  Future<bool> exists() async => existsMock;

  bool existsSyncMock = true;

  @override
  bool existsSync() => existsSyncMock;

  bool isAbsoluteMock = true;

  @override
  bool get isAbsolute => isAbsoluteMock;

  @override
  Future<DateTime> lastAccessed() {
    throw UnimplementedError();
  }

  @override
  DateTime lastAccessedSync() {
    throw UnimplementedError();
  }

  @override
  Future<DateTime> lastModified() {
    throw UnimplementedError();
  }

  @override
  DateTime lastModifiedSync() {
    throw UnimplementedError();
  }

  @override
  Future<int> length() {
    throw UnimplementedError();
  }

  @override
  int lengthSync() {
    throw UnimplementedError();
  }

  @override
  Future<RandomAccessFile> open({FileMode mode = FileMode.read}) {
    throw UnimplementedError();
  }

  @override
  Stream<List<int>> openRead([int? start, int? end]) {
    throw UnimplementedError();
  }

  @override
  RandomAccessFile openSync({FileMode mode = FileMode.read}) {
    throw UnimplementedError();
  }

  @override
  IOSink openWrite({FileMode mode = FileMode.write, Encoding encoding = utf8}) {
    throw UnimplementedError();
  }

  late Directory parentMock;

  @override
  Directory get parent => parentMock;

  late String pathMock;

  @override
  String get path => pathMock;

  late Uint8List readAsBytesMock;

  @override
  Future<Uint8List> readAsBytes() async => readAsBytesMock;

  late Uint8List readAsBytesSyncMock;

  @override
  Uint8List readAsBytesSync() => readAsBytesSyncMock;

  late List<String> readAsLinesMock;

  @override
  Future<List<String>> readAsLines({Encoding encoding = utf8}) async =>
      readAsLinesMock;

  late List<String> readAsLinesSyncMock;

  @override
  List<String> readAsLinesSync({Encoding encoding = utf8}) =>
      readAsLinesSyncMock;

  late String readAsStringMock;

  @override
  Future<String> readAsString({Encoding encoding = utf8}) async =>
      readAsStringMock;

  late String readAsStringSyncMock;

  @override
  String readAsStringSync({Encoding encoding = utf8}) => readAsStringSyncMock;

  late File renameMock;
  @override
  Future<File> rename(String newPath) async => renameMock;

  @override
  File renameSync(String newPath) {
    throw UnimplementedError();
  }

  @override
  Future<String> resolveSymbolicLinks() {
    throw UnimplementedError();
  }

  @override
  String resolveSymbolicLinksSync() {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> setLastAccessed(DateTime time) {
    throw UnimplementedError();
  }

  @override
  void setLastAccessedSync(DateTime time) {}

  @override
  Future<dynamic> setLastModified(DateTime time) {
    throw UnimplementedError();
  }

  @override
  void setLastModifiedSync(DateTime time) {}

  @override
  Future<FileStat> stat() {
    throw UnimplementedError();
  }

  @override
  FileStat statSync() {
    throw UnimplementedError();
  }

  @override
  Uri get uri => throw UnimplementedError();

  @override
  Stream<FileSystemEvent> watch(
      {int events = FileSystemEvent.all, bool recursive = false}) {
    throw UnimplementedError();
  }

  @override
  Future<File> writeAsBytes(List<int> bytes,
      {FileMode mode = FileMode.write, bool flush = false}) {
    throw UnimplementedError();
  }

  @override
  void writeAsBytesSync(List<int> bytes,
      {FileMode mode = FileMode.write, bool flush = false}) {}

  late File writeAsStringMock;
  late String writeAsStringResult;

  @override
  Future<File> writeAsString(String contents,
      {FileMode mode = FileMode.write,
      Encoding encoding = utf8,
      bool flush = false}) async {
    writeAsStringResult = contents;
    return writeAsStringMock;
  }

  late File writeAsStringSyncMock;

  @override
  void writeAsStringSync(String contents,
      {FileMode mode = FileMode.write,
      Encoding encoding = utf8,
      bool flush = false}) {}
}
