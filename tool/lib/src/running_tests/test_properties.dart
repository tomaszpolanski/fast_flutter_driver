import 'package:args/args.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/running_tests/resolution.dart';

class TestProperties {
  TestProperties(List<String> args) : _arguments = testParameters.parse(args);

  final ArgResults _arguments;

  String get vmUrl => _arguments[url];

  bool get screenshotsEnabled => _arguments[screenshotsArg] ?? false;

  String get locale => _arguments[languageArg];

  Resolution get resolution => Resolution.fromSize(_arguments[resolutionArg]);

  TestPlatform get platform =>
      TestPlatformEx.fromString(_arguments[platformArg]);
}

abstract class BaseConfiguration {
  Resolution get resolution;

  TestPlatform get platform;

  Map<String, dynamic> toJson();
}
