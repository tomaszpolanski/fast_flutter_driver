import 'package:args/args.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/resolution.dart';

/// Properties that are passed to the tests from command line
class TestProperties {
  TestProperties(List<String> args) : arguments = testParameters.parse(args);

  /// Parsed representation of the arguments that can be extended to your liking
  final ArgResults arguments;

  /// Current dart VM address used by FlutterDriver to connect to the app
  String get vmUrl => arguments[url];

  /// Flag passed via command line (with --screenshots) if the tests should
  /// make screenshots.
  /// Screenshots are not handled by fastdriver. Developer is responsible
  /// for making screenshot when this flag is passed
  bool get screenshotsEnabled => arguments[screenshotsArg] ?? false;

  /// Current locale/locale passed from fastdriver via --language.
  /// This property can be used in tests to set appropriate application language
  String get locale => arguments[languageArg];

  /// Describes what size should be the application window on Desktop.
  /// This value is passed via fastdriver command using --resolution option.
  /// This is ignored on mobile.
  Resolution get resolution => Resolution.fromSize(arguments[resolutionArg]);

  /// Describes what platform's UI should be rendered in the application.
  /// This value is passed via fastdriver command using --platform option.
  /// This value should be handled on the application side - fastdriver just
  /// passes it.
  TestPlatform? get platform =>
      TestPlatformEx.fromString(arguments[platformArg]);

  /// Additional parameters passed via --test-args from fastdriver.
  /// This is used to extend the capabilities of your tests without the need
  /// of modifying fastdriver's code.
  String get additionalArgs => arguments[testArg];
}

/// Base configuration that will be passed from tests to the application
abstract class BaseConfiguration {
  /// Describes what size should be the application window on Desktop.
  /// This value is passed via fastdriver command using --resolution option.
  /// This is ignored on mobile.
  Resolution get resolution;

  /// Describes what platform's UI should be rendered in the application.
  /// This value is passed via fastdriver command using --platform option.
  /// This value should be handled on the application side - fastdriver just
  /// passes it.
  TestPlatform get platform;

  /// Serializes [BaseConfiguration] to json.
  Map<String, dynamic> toJson();
}
