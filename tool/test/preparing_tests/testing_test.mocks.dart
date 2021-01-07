import 'package:mockito/mockito.dart' as _i1;
import 'package:cli_util/cli_logging.dart' as _i2;
import 'dart:io' as _i3;
import 'dart:typed_data' as _i4;
import 'dart:async' as _i5;
import 'dart:convert' as _i6;
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line/streams.dart'
    as _i7;

class _FakeAnsi extends _i1.Fake implements _i2.Ansi {}

class _FakeProgress extends _i1.Fake implements _i2.Progress {}

class _FakeFile extends _i1.Fake implements _i3.File {}

class _FakeDateTime extends _i1.Fake implements DateTime {}

class _FakeRandomAccessFile extends _i1.Fake implements _i3.RandomAccessFile {}

class _FakeIOSink extends _i1.Fake implements _i3.IOSink {}

class _FakeUint8List extends _i1.Fake implements _i4.Uint8List {}

class _FakeUri extends _i1.Fake implements Uri {}

class _FakeDirectory extends _i1.Fake implements _i3.Directory {}

class _FakeStreamController<T> extends _i1.Fake
    implements _i5.StreamController<T> {}

class _FakeDuration extends _i1.Fake implements Duration {}

/// A class which mocks [Logger].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogger extends _i1.Mock implements _i2.Logger {
  MockLogger() {
    _i1.throwOnMissingStub(this);
  }

  _i2.Ansi get ansi =>
      super.noSuchMethod(Invocation.getter(#ansi), _FakeAnsi());
  bool get isVerbose =>
      super.noSuchMethod(Invocation.getter(#isVerbose), false);
  void stderr(String? message) =>
      super.noSuchMethod(Invocation.method(#stderr, [message]));
  void stdout(String? message) =>
      super.noSuchMethod(Invocation.method(#stdout, [message]));
  void trace(String? message) =>
      super.noSuchMethod(Invocation.method(#trace, [message]));
  void write(String? message) =>
      super.noSuchMethod(Invocation.method(#write, [message]));
  void writeCharCode(int? charCode) =>
      super.noSuchMethod(Invocation.method(#writeCharCode, [charCode]));
  _i2.Progress progress(String? message) => (super.noSuchMethod(
          Invocation.method(#progress, [message]), _FakeProgress())
      as _i2.Progress);
}

/// A class which mocks [File].
///
/// See the documentation for Mockito's code generation for more information.
class MockFile extends _i1.Mock implements _i3.File {
  MockFile() {
    _i1.throwOnMissingStub(this);
  }

  _i3.File get absolute =>
      super.noSuchMethod(Invocation.getter(#absolute), _FakeFile());
  String get path => super.noSuchMethod(Invocation.getter(#path), '');
  _i5.Future<_i3.File> create({bool? recursive}) => (super.noSuchMethod(
      Invocation.method(#create, [], {#recursive: recursive}),
      Future.value(_FakeFile())) as _i5.Future<_i3.File>);
  void createSync({bool? recursive}) => super.noSuchMethod(
      Invocation.method(#createSync, [], {#recursive: recursive}));
  _i5.Future<_i3.File> rename(String? newPath) => (super.noSuchMethod(
          Invocation.method(#rename, [newPath]), Future.value(_FakeFile()))
      as _i5.Future<_i3.File>);
  _i3.File renameSync(String? newPath) => (super.noSuchMethod(
      Invocation.method(#renameSync, [newPath]), _FakeFile()) as _i3.File);
  _i5.Future<_i3.File> copy(String? newPath) => (super.noSuchMethod(
          Invocation.method(#copy, [newPath]), Future.value(_FakeFile()))
      as _i5.Future<_i3.File>);
  _i3.File copySync(String? newPath) =>
      (super.noSuchMethod(Invocation.method(#copySync, [newPath]), _FakeFile())
          as _i3.File);
  _i5.Future<int> length() =>
      (super.noSuchMethod(Invocation.method(#length, []), Future.value(0))
          as _i5.Future<int>);
  int lengthSync() =>
      (super.noSuchMethod(Invocation.method(#lengthSync, []), 0) as int);
  _i5.Future<DateTime> lastAccessed() => (super.noSuchMethod(
          Invocation.method(#lastAccessed, []), Future.value(_FakeDateTime()))
      as _i5.Future<DateTime>);
  DateTime lastAccessedSync() => (super.noSuchMethod(
      Invocation.method(#lastAccessedSync, []), _FakeDateTime()) as DateTime);
  _i5.Future<dynamic> setLastAccessed(DateTime? time) => (super.noSuchMethod(
          Invocation.method(#setLastAccessed, [time]), Future.value(null))
      as _i5.Future<dynamic>);
  void setLastAccessedSync(DateTime? time) =>
      super.noSuchMethod(Invocation.method(#setLastAccessedSync, [time]));
  _i5.Future<DateTime> lastModified() => (super.noSuchMethod(
          Invocation.method(#lastModified, []), Future.value(_FakeDateTime()))
      as _i5.Future<DateTime>);
  DateTime lastModifiedSync() => (super.noSuchMethod(
      Invocation.method(#lastModifiedSync, []), _FakeDateTime()) as DateTime);
  _i5.Future<dynamic> setLastModified(DateTime? time) => (super.noSuchMethod(
          Invocation.method(#setLastModified, [time]), Future.value(null))
      as _i5.Future<dynamic>);
  void setLastModifiedSync(DateTime? time) =>
      super.noSuchMethod(Invocation.method(#setLastModifiedSync, [time]));
  _i5.Future<_i3.RandomAccessFile> open({_i3.FileMode? mode}) =>
      (super.noSuchMethod(Invocation.method(#open, [], {#mode: mode}),
              Future.value(_FakeRandomAccessFile()))
          as _i5.Future<_i3.RandomAccessFile>);
  _i3.RandomAccessFile openSync({_i3.FileMode? mode}) => (super.noSuchMethod(
      Invocation.method(#openSync, [], {#mode: mode}),
      _FakeRandomAccessFile()) as _i3.RandomAccessFile);
  _i5.Stream<List<int>> openRead([int? start, int? end]) => (super.noSuchMethod(
          Invocation.method(#openRead, [start, end]), Stream<List<int>>.empty())
      as _i5.Stream<List<int>>);
  _i3.IOSink openWrite({_i3.FileMode? mode, _i6.Encoding? encoding}) =>
      (super.noSuchMethod(
          Invocation.method(#openWrite, [], {#mode: mode, #encoding: encoding}),
          _FakeIOSink()) as _i3.IOSink);
  _i5.Future<_i4.Uint8List> readAsBytes() => (super.noSuchMethod(
          Invocation.method(#readAsBytes, []), Future.value(_FakeUint8List()))
      as _i5.Future<_i4.Uint8List>);
  _i4.Uint8List readAsBytesSync() => (super.noSuchMethod(
          Invocation.method(#readAsBytesSync, []), _FakeUint8List())
      as _i4.Uint8List);
  _i5.Future<String> readAsString({_i6.Encoding? encoding}) =>
      (super.noSuchMethod(
          Invocation.method(#readAsString, [], {#encoding: encoding}),
          Future.value('')) as _i5.Future<String>);
  String readAsStringSync({_i6.Encoding? encoding}) => (super.noSuchMethod(
          Invocation.method(#readAsStringSync, [], {#encoding: encoding}), '')
      as String);
  _i5.Future<List<String>> readAsLines({_i6.Encoding? encoding}) =>
      (super.noSuchMethod(
          Invocation.method(#readAsLines, [], {#encoding: encoding}),
          Future.value(<String>[])) as _i5.Future<List<String>>);
  List<String> readAsLinesSync({_i6.Encoding? encoding}) => (super.noSuchMethod(
      Invocation.method(#readAsLinesSync, [], {#encoding: encoding}),
      <String>[]) as List<String>);
  _i5.Future<_i3.File> writeAsBytes(List<int>? bytes,
          {_i3.FileMode? mode, bool? flush}) =>
      (super.noSuchMethod(
          Invocation.method(
              #writeAsBytes, [bytes], {#mode: mode, #flush: flush}),
          Future.value(_FakeFile())) as _i5.Future<_i3.File>);
  void writeAsBytesSync(List<int>? bytes, {_i3.FileMode? mode, bool? flush}) =>
      super.noSuchMethod(Invocation.method(
          #writeAsBytesSync, [bytes], {#mode: mode, #flush: flush}));
  _i5.Future<_i3.File> writeAsString(String? contents,
          {_i3.FileMode? mode, _i6.Encoding? encoding, bool? flush}) =>
      (super.noSuchMethod(
          Invocation.method(#writeAsString, [contents],
              {#mode: mode, #encoding: encoding, #flush: flush}),
          Future.value(_FakeFile())) as _i5.Future<_i3.File>);
  void writeAsStringSync(String? contents,
          {_i3.FileMode? mode, _i6.Encoding? encoding, bool? flush}) =>
      super.noSuchMethod(Invocation.method(#writeAsStringSync, [contents],
          {#mode: mode, #encoding: encoding, #flush: flush}));
}

/// A class which mocks [Directory].
///
/// See the documentation for Mockito's code generation for more information.
class MockDirectory extends _i1.Mock implements _i3.Directory {
  MockDirectory() {
    _i1.throwOnMissingStub(this);
  }

  String get path => super.noSuchMethod(Invocation.getter(#path), '');
  Uri get uri => super.noSuchMethod(Invocation.getter(#uri), _FakeUri());
  _i3.Directory get absolute =>
      super.noSuchMethod(Invocation.getter(#absolute), _FakeDirectory());
  _i5.Future<_i3.Directory> create({bool? recursive}) => (super.noSuchMethod(
      Invocation.method(#create, [], {#recursive: recursive}),
      Future.value(_FakeDirectory())) as _i5.Future<_i3.Directory>);
  void createSync({bool? recursive}) => super.noSuchMethod(
      Invocation.method(#createSync, [], {#recursive: recursive}));
  _i5.Future<_i3.Directory> createTemp([String? prefix]) => (super.noSuchMethod(
      Invocation.method(#createTemp, [prefix]),
      Future.value(_FakeDirectory())) as _i5.Future<_i3.Directory>);
  _i3.Directory createTempSync([String? prefix]) => (super.noSuchMethod(
          Invocation.method(#createTempSync, [prefix]), _FakeDirectory())
      as _i3.Directory);
  _i5.Future<String> resolveSymbolicLinks() => (super.noSuchMethod(
          Invocation.method(#resolveSymbolicLinks, []), Future.value(''))
      as _i5.Future<String>);
  String resolveSymbolicLinksSync() =>
      (super.noSuchMethod(Invocation.method(#resolveSymbolicLinksSync, []), '')
          as String);
  _i5.Future<_i3.Directory> rename(String? newPath) => (super.noSuchMethod(
          Invocation.method(#rename, [newPath]), Future.value(_FakeDirectory()))
      as _i5.Future<_i3.Directory>);
  _i3.Directory renameSync(String? newPath) => (super.noSuchMethod(
          Invocation.method(#renameSync, [newPath]), _FakeDirectory())
      as _i3.Directory);
  _i5.Stream<_i3.FileSystemEntity> list({bool? recursive, bool? followLinks}) =>
      (super.noSuchMethod(
              Invocation.method(#list, [],
                  {#recursive: recursive, #followLinks: followLinks}),
              Stream<_i3.FileSystemEntity>.empty())
          as _i5.Stream<_i3.FileSystemEntity>);
  List<_i3.FileSystemEntity> listSync({bool? recursive, bool? followLinks}) =>
      (super.noSuchMethod(
          Invocation.method(#listSync, [],
              {#recursive: recursive, #followLinks: followLinks}),
          <_i3.FileSystemEntity>[]) as List<_i3.FileSystemEntity>);
  String toString() =>
      (super.noSuchMethod(Invocation.method(#toString, []), '') as String);
}

/// A class which mocks [InputCommandLineStream].
///
/// See the documentation for Mockito's code generation for more information.
class MockInputCommandLineStream extends _i1.Mock
    implements _i7.InputCommandLineStream {
  MockInputCommandLineStream() {
    _i1.throwOnMissingStub(this);
  }

  _i5.StreamController<String> get input => super
      .noSuchMethod(Invocation.getter(#input), _FakeStreamController<String>());
  set input(_i5.StreamController<String>? _input) =>
      super.noSuchMethod(Invocation.setter(#input, [_input]));
  _i5.Stream<List<int>> get stream =>
      super.noSuchMethod(Invocation.getter(#stream), Stream<List<int>>.empty());
  void write(String? line) =>
      super.noSuchMethod(Invocation.method(#write, [line]));
  _i5.Future<void> dispose() =>
      (super.noSuchMethod(Invocation.method(#dispose, []), Future.value(null))
          as _i5.Future<void>);
}

/// A class which mocks [Progress].
///
/// See the documentation for Mockito's code generation for more information.
class MockProgress extends _i1.Mock implements _i2.Progress {
  MockProgress() {
    _i1.throwOnMissingStub(this);
  }

  String get message => super.noSuchMethod(Invocation.getter(#message), '');
  Duration get elapsed =>
      super.noSuchMethod(Invocation.getter(#elapsed), _FakeDuration());
  void finish({String? message, bool? showTiming = false}) =>
      super.noSuchMethod(Invocation.method(
          #finish, [], {#message: message, #showTiming: showTiming}));
}
