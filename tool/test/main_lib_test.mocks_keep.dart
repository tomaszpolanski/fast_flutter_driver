import 'dart:async' as _i8;
import 'dart:io' as _i7;

import 'package:cli_util/cli_logging.dart' as _i2;
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line/command_line_impl.dart'
    as _i10;
import 'package:fast_flutter_driver_tool/src/preparing_tests/command_line/streams.dart'
    as _i6;
import 'package:fast_flutter_driver_tool/src/preparing_tests/test_generator/test_generator.dart'
    as _i11;
import 'package:fast_flutter_driver_tool/src/preparing_tests/testing.dart'
    as _i9;
import 'package:fast_flutter_driver_tool/src/update/path_provider_impl.dart'
    as _i3;
import 'package:fast_flutter_driver_tool/src/update/version.dart' as _i5;
import 'package:http/src/response.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

class _FakeAnsi extends _i1.Fake implements _i2.Ansi {}

class _FakeProgress extends _i1.Fake implements _i2.Progress {}

class _FakePathProvider extends _i1.Fake implements _i3.PathProvider {}

class _FakeResponse extends _i1.Fake implements _i4.Response {}

class _FakeAppVersion extends _i1.Fake implements _i5.AppVersion {}

class _FakeOutputCommandLineStream extends _i1.Fake
    implements _i6.OutputCommandLineStream {}

class _FakeInputCommandLineStream extends _i1.Fake
    implements _i6.InputCommandLineStream {}

class _FakeLogger extends _i1.Fake implements _i2.Logger {}

class _FakeUri extends _i1.Fake implements Uri {}

class _FakeDirectory extends _i1.Fake implements _i7.Directory {}

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

/// A class which mocks [VersionChecker].
///
/// See the documentation for Mockito's code generation for more information.
class MockVersionChecker extends _i1.Mock implements _i5.VersionChecker {
  MockVersionChecker() {
    _i1.throwOnMissingStub(this);
  }

  _i3.PathProvider get pathProvider =>
      super.noSuchMethod(Invocation.getter(#pathProvider), _FakePathProvider());
  _i8.Future<_i4.Response> Function(String) get httpGet => super.noSuchMethod(
      Invocation.getter(#httpGet),
      (String url) => Future.value(_FakeResponse()));
  _i8.Future<String?> currentVersion() => (super.noSuchMethod(
          Invocation.method(#currentVersion, []), Future.value(''))
      as _i8.Future<String?>);
  _i8.Future<String> remoteVersion() => (super
          .noSuchMethod(Invocation.method(#remoteVersion, []), Future.value(''))
      as _i8.Future<String>);
  _i8.Future<_i5.AppVersion?> checkForUpdates() => (super.noSuchMethod(
      Invocation.method(#checkForUpdates, []),
      Future.value(_FakeAppVersion())) as _i8.Future<_i5.AppVersion?>);
}

/// A class which mocks [TestExecutor].
///
/// See the documentation for Mockito's code generation for more information.
class MockTestExecutor extends _i1.Mock implements _i9.TestExecutor {
  MockTestExecutor() {
    _i1.throwOnMissingStub(this);
  }

  _i6.OutputFactory get outputFactory => super.noSuchMethod(
      Invocation.getter(#outputFactory),
      (void Function(String) onData) => _FakeOutputCommandLineStream());
  _i6.InputFactory get inputFactory => super.noSuchMethod(
      Invocation.getter(#inputFactory), () => _FakeInputCommandLineStream());
  _i10.RunCommand get run => super.noSuchMethod(
      Invocation.getter(#run),
      (String command,
              {_i6.OutputCommandLineStream? stderr,
              _i6.InputCommandLineStream? stdin,
              required _i6.OutputCommandLineStream stdout}) =>
          Future.value(null));
  _i2.Logger get logger =>
      super.noSuchMethod(Invocation.getter(#logger), _FakeLogger());
  _i8.Future<void> test(String? testFile,
          {_i9.ExecutorParameters? parameters}) =>
      (super.noSuchMethod(
          Invocation.method(#test, [testFile], {#parameters: parameters}),
          Future.value(null)) as _i8.Future<void>);
}

/// A class which mocks [TestFileProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockTestFileProvider extends _i1.Mock implements _i11.TestFileProvider {
  MockTestFileProvider() {
    _i1.throwOnMissingStub(this);
  }

  _i2.Logger get logger =>
      super.noSuchMethod(Invocation.getter(#logger), _FakeLogger());
  _i8.Future<String?> testFile(String? path) => (super
          .noSuchMethod(Invocation.method(#testFile, [path]), Future.value(''))
      as _i8.Future<String?>);
}

/// A class which mocks [Directory].
///
/// See the documentation for Mockito's code generation for more information.
class MockDirectory extends _i1.Mock implements _i7.Directory {
  MockDirectory() {
    _i1.throwOnMissingStub(this);
  }

  String get path => super.noSuchMethod(Invocation.getter(#path), '');
  Uri get uri => super.noSuchMethod(Invocation.getter(#uri), _FakeUri());
  _i7.Directory get absolute =>
      super.noSuchMethod(Invocation.getter(#absolute), _FakeDirectory());
  _i8.Future<_i7.Directory> create({bool? recursive}) => (super.noSuchMethod(
      Invocation.method(#create, [], {#recursive: recursive}),
      Future.value(_FakeDirectory())) as _i8.Future<_i7.Directory>);
  void createSync({bool? recursive}) => super.noSuchMethod(
      Invocation.method(#createSync, [], {#recursive: recursive}));
  _i8.Future<_i7.Directory> createTemp([String? prefix]) => (super.noSuchMethod(
      Invocation.method(#createTemp, [prefix]),
      Future.value(_FakeDirectory())) as _i8.Future<_i7.Directory>);
  _i7.Directory createTempSync([String? prefix]) => (super.noSuchMethod(
          Invocation.method(#createTempSync, [prefix]), _FakeDirectory())
      as _i7.Directory);
  _i8.Future<String> resolveSymbolicLinks() => (super.noSuchMethod(
          Invocation.method(#resolveSymbolicLinks, []), Future.value(''))
      as _i8.Future<String>);
  String resolveSymbolicLinksSync() =>
      (super.noSuchMethod(Invocation.method(#resolveSymbolicLinksSync, []), '')
          as String);
  _i8.Future<_i7.Directory> rename(String? newPath) => (super.noSuchMethod(
          Invocation.method(#rename, [newPath]), Future.value(_FakeDirectory()))
      as _i8.Future<_i7.Directory>);
  _i7.Directory renameSync(String? newPath) => (super.noSuchMethod(
          Invocation.method(#renameSync, [newPath]), _FakeDirectory())
      as _i7.Directory);
  _i8.Stream<_i7.FileSystemEntity> list({bool? recursive, bool? followLinks}) =>
      (super.noSuchMethod(
              Invocation.method(#list, [],
                  {#recursive: recursive, #followLinks: followLinks}),
              Stream<_i7.FileSystemEntity>.empty())
          as _i8.Stream<_i7.FileSystemEntity>);
  List<_i7.FileSystemEntity> listSync({bool? recursive, bool? followLinks}) =>
      (super.noSuchMethod(
          Invocation.method(#listSync, [],
              {#recursive: recursive, #followLinks: followLinks}),
          <_i7.FileSystemEntity>[]) as List<_i7.FileSystemEntity>);
  String toString() =>
      (super.noSuchMethod(Invocation.method(#toString, []), '') as String);
}
