import 'package:mockito/mockito.dart' as _i1;
import 'package:cli_util/cli_logging.dart' as _i2;

class _FakeAnsi extends _i1.Fake implements _i2.Ansi {}

class _FakeProgress extends _i1.Fake implements _i2.Progress {}

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
