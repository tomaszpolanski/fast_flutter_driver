// Mocks generated by Mockito 5.0.0-nullsafety.7 from annotations
// in fast_flutter_driver_tool/test/utils/lazy_logger_test.dart.
// Do not manually edit this file.

import 'package:cli_util/cli_logging.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

class _FakeAnsi extends _i1.Fake implements _i2.Ansi {}

class _FakeProgress extends _i1.Fake implements _i2.Progress {}

class _FakeDuration extends _i1.Fake implements Duration {}

/// A class which mocks [Logger].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogger extends _i1.Mock implements _i2.Logger {
  MockLogger() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Ansi get ansi =>
      (super.noSuchMethod(Invocation.getter(#ansi), returnValue: _FakeAnsi())
          as _i2.Ansi);
  @override
  bool get isVerbose =>
      (super.noSuchMethod(Invocation.getter(#isVerbose), returnValue: false)
          as bool);
  @override
  void stderr(String? message) =>
      super.noSuchMethod(Invocation.method(#stderr, [message]),
          returnValueForMissingStub: null);
  @override
  void stdout(String? message) =>
      super.noSuchMethod(Invocation.method(#stdout, [message]),
          returnValueForMissingStub: null);
  @override
  void trace(String? message) =>
      super.noSuchMethod(Invocation.method(#trace, [message]),
          returnValueForMissingStub: null);
  @override
  void write(String? message) =>
      super.noSuchMethod(Invocation.method(#write, [message]),
          returnValueForMissingStub: null);
  @override
  void writeCharCode(int? charCode) =>
      super.noSuchMethod(Invocation.method(#writeCharCode, [charCode]),
          returnValueForMissingStub: null);
  @override
  _i2.Progress progress(String? message) =>
      (super.noSuchMethod(Invocation.method(#progress, [message]),
          returnValue: _FakeProgress()) as _i2.Progress);
}

/// A class which mocks [Progress].
///
/// See the documentation for Mockito's code generation for more information.
class MockProgress extends _i1.Mock implements _i2.Progress {
  MockProgress() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get message =>
      (super.noSuchMethod(Invocation.getter(#message), returnValue: '')
          as String);
  @override
  Duration get elapsed => (super.noSuchMethod(Invocation.getter(#elapsed),
      returnValue: _FakeDuration()) as Duration);
  @override
  void finish({String? message, bool? showTiming = false}) =>
      super.noSuchMethod(
          Invocation.method(
              #finish, [], {#message: message, #showTiming: showTiming}),
          returnValueForMissingStub: null);
}