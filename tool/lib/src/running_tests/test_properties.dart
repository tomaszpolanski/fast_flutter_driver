import 'package:args/args.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/resolution.dart';

class TestProperties {
  TestProperties(List<String> args) : arguments = testParameters.parse(args);

  final ArgResults arguments;

  String get vmUrl => arguments[url];

  bool get screenshotsEnabled => arguments[screenshotsArg] ?? false;

  String get locale => arguments[languageArg];

  Resolution get resolution => Resolution.fromSize(arguments[resolutionArg]);

  TestPlatform get platform =>
      TestPlatformEx.fromString(arguments[platformArg]);
}

abstract class BaseConfiguration {
  Resolution get resolution;

  TestPlatform get platform;

  Map<String, dynamic> toJson();
}
