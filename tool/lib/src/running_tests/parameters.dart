import 'package:args/args.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/utils/enum.dart';

/// Parameter parser that parses arguments that were passed from command line
/// to Flutter Driver tests
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
  )
  ..addOption(
    testArg,
    help: 'Additional parameters passed from the fastdriver',
  );

/// UI platform for the application
enum TestPlatform {
  android,
  iOS,
}

/// Extension method to make converting [TestPlatform] to String easier
extension TestPlatformEnum on TestPlatform {
  /// Converts [TestPlatform] to user readable string
  String asString() => fromEnum(this);
}

/// Extension method to make converting String to [TestPlatform] easier.
abstract class TestPlatformEx {
  /// Converts user readable string to [TestPlatform]
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
