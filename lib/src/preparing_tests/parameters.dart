import 'package:args/args.dart';
import 'package:fast_flutter_driver/src/running_tests/test/parameters.dart';
import 'package:fast_flutter_driver/src/utils/colorizing.dart';

const fileArg = 'file';
const directoryArg = 'directory';
const languageArg = 'language';
const screenshotsArg = 'screenshots';
const resolutionArg = 'resolution';
const helpArg = 'help';
const url = 'url';
const platformArg = 'platform';

ArgParser scriptParameters = ArgParser()
  ..addOption(
    fileArg,
    abbr: fileArg[0],
    help: 'Run single test file',
  )
  ..addOption(
    directoryArg,
    abbr: directoryArg[0],
    defaultsTo: 'test_driver',
    help: 'Run all the tests in the directory recursively',
  )
  ..addOption(
    languageArg,
    abbr: languageArg[0],
    defaultsTo: 'en',
    help: 'System language',
  )
  ..addOption(
    platformArg,
    abbr: platformArg[0],
    help: 'Overwritten platform of the device. \n'
        'Possible options: ${TestPlatform.values.map(fromEnum).join(', ')}',
  )
  ..addOption(
    resolutionArg,
    abbr: resolutionArg[0],
    help: 'Resolution of the application '
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
  );

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
    ${green('flutter config --enable-linux-desktop --enable-macos-desktop --enable-windows-desktop')}'
  • Run the tests again in verbose mode:
    ${green('$command -v')}''',
  );
}
