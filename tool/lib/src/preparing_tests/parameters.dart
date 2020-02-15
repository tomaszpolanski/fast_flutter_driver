import 'package:args/args.dart';
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
const verboseArg = 'verbose';

ArgParser scriptParameters = ArgParser()
  ..addOption(
    deviceArg,
    abbr: deviceArg[0],
    help: 'Runs testing on a specyfic device',
    defaultsTo: devices.device,
  )
  ..addOption(
    languageArg,
    abbr: languageArg[0],
    defaultsTo: 'en',
    help: 'Application\'s language',
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
  ..addFlag(verboseArg,
      abbr: verboseArg[0],
      help: 'Show verbose loggin',
      negatable: false,
      defaultsTo: false);

void printErrorHelp(String command) {
  // ignore: avoid_print
  print(
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
