import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:fast_flutter_driver_tool/src/preparing_tests/devices.dart'
    as devices;
import 'package:fast_flutter_driver_tool/src/running_tests/parameters.dart';
import 'package:fast_flutter_driver_tool/src/utils/colorizing.dart';
import 'package:fast_flutter_driver_tool/src/utils/enum.dart';

const languageArg = 'language';
const screenshotsArg = 'screenshots';
const resolutionArg = 'resolution';
const helpArg = 'help';
const url = 'url';
const platformArg = 'platform';
const deviceArg = 'device';
const flavorArg = 'flavor';
const verboseArg = 'verbose';
const versionArg = 'version';
const flutterArg = 'flutter-args';
const dartArg = 'dart-args';
const testArg = 'test-args';

ArgParser scriptParameters = ArgParser()
  ..addOption(
    deviceArg,
    abbr: deviceArg[0],
    help: 'Runs testing on a given device',
    defaultsTo: devices.device,
  )
  ..addOption(
    languageArg,
    abbr: languageArg[0],
    defaultsTo: 'en',
    help: "Application's language",
  )
  ..addOption(
    platformArg,
    abbr: platformArg[0],
    help: 'Overwrite the platform of a device. \n'
        'Possible options: ${TestPlatform.values.map(fromEnum).join(', ')}',
  )
  ..addOption(
    resolutionArg,
    abbr: resolutionArg[0],
    help: 'The resolution of an application '
        'in format <width>x<height>, eg 800x600',
    defaultsTo: '400x700',
  )
  ..addOption(
    flavorArg,
    help: '''
Build a custom app flavor as defined by platform-specific build setup.
Supports the use of product flavors in Android Gradle scripts, and the use of custom Xcode schemes.
''',
  )
  ..addOption(
    flutterArg,
    help: '''
Arguments to be passed while running the app via `flutter run`.
''',
  )
  ..addOption(
    dartArg,
    help: '''
Arguments to be passed to dart while running test file.
''',
  )
  ..addOption(
    testArg,
    help: '''
Additional arguments to be passed to the test. 
This is used to extend test functionality and this value will be passed as `TestProperties::additionalArgs`.
''',
  )
  ..addFlag(
    screenshotsArg,
    abbr: screenshotsArg[0],
    help: 'Enables screenshots during test run',
  )
  ..addFlag(
    helpArg,
    abbr: helpArg[0],
    help: 'Display this help message',
    negatable: false,
  )
  ..addFlag(
    verboseArg,
    abbr: verboseArg[0],
    help: 'Show verbose logs',
    negatable: false,
  )
  ..addFlag(
    versionArg,
    help: "Script's version",
    negatable: false,
  );

void printErrorHelp(String command, {required Logger logger}) {
  logger.stdout(
    '''
${red('Failed')} to run command '${yellow(command)}'
To ${green('fix')} it:
  • Close already running application
  • Clean workspace by running:
    ${green('flutter clean')}
  • Enable desktop by running: 
    ${green('flutter config --enable-linux-desktop --enable-macos-desktop --enable-windows-desktop')}
  • Run the tests again in verbose mode:
    ${green('$command -v')}''',
  );
}
