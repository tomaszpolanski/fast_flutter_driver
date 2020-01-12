import 'package:args/args.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/utils/enum.dart';

ArgParser testParameters = ArgParser()
  ..addOption(
    url,
    abbr: url[0],
    help: 'Url for dartVmServiceUrl',
  )
  ..addOption(
    resolutionArg,
    abbr: resolutionArg[0],
    help: 'Resolution of the device',
  )
  ..addFlag(
    screenshotsArg,
    abbr: screenshotsArg[0],
    help: 'Use screenshots',
  )
  ..addOption(
    languageArg,
    abbr: languageArg[0],
    defaultsTo: 'en',
    help: 'The language of the device',
  )
  ..addOption(
    platformArg,
    abbr: platformArg[0],
    help: 'Overwritten platform of the device',
  );

enum TestPlatform {
  android,
  iOS,
}

extension TestPlatformEnum on TestPlatform {
  String asString() => fromEnum(this);
}

abstract class TestPlatformEx {
  static TestPlatform fromString(String value) {
    switch (value?.toLowerCase()) {
      case 'android':
        return TestPlatform.android;
      case 'ios':
        return TestPlatform.iOS;
      default:
        return null;
    }
  }
}
