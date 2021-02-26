import 'package:fast_flutter_driver_tool/src/utils/colorize/src/colorize.dart';
import 'package:fast_flutter_driver_tool/src/utils/colorize/src/styles.dart';

/// Changes the color of the text in the console to green
Colorize green(String text) => Colorize(text)..apply(Styles.LIGHT_GREEN);

/// Changes the color of the text in the console to yellow
Colorize yellow(String text) => Colorize(text)..apply(Styles.LIGHT_YELLOW);

/// Changes the color of the text in the console to red
Colorize red(String text) => Colorize(text)..apply(Styles.LIGHT_RED);

/// Changes the text in the console to be bold
Colorize bold(String text) => Colorize(text)..apply(Styles.BOLD);
