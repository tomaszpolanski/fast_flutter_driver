import 'package:args/args.dart';
import 'package:fast_flutter_driver/src/src/parameters.dart';
import 'package:fast_flutter_driver/src/src/resolution.dart';

const url = 'url';
const screenshots = 'screenshots';
const resolutionArg = 'resolution';
const languageArg = 'language';
const platformArg = 'platform';

ArgParser testParser = ArgParser()
  ..addOption(
    url,
    abbr: url[0],
    help: 'Url for dartVmServiceUrl',
  )
  ..addOption(
    resolutionArg,
    abbr: resolutionArg[0],
    help: 'Resolution of device',
  )
  ..addFlag(
    screenshots,
    abbr: screenshots[0],
    help: 'Use screenshots',
  )
  ..addOption(
    languageArg,
    abbr: languageArg[0],
    defaultsTo: 'en',
    help: 'Language of the device',
  )
  ..addOption(
    platformArg,
    abbr: platformArg[0],
    help: 'Overwritten platform of the device',
  );

class TestProperties {
  TestProperties(List<String> args) : _arguments = testParser.parse(args);

  final ArgResults _arguments;

  String get vmUrl => _arguments[url];

  bool get screenshotsEnabled => _arguments[screenshots] ?? false;

  String get locale => _arguments[languageArg];

  Resolution get resolution => Resolution.fromSize(_arguments[resolutionArg]);

  TestPlatform get platform => platformFromString(_arguments[platformArg]);
}

abstract class BaseConfiguration {
  Resolution get resolution;

  TestPlatform get platform;

  Map<String, dynamic> toJson();
}
