import 'package:colorize/colorize.dart';

Colorize green(String text) => Colorize(text).apply(Styles.LIGHT_GREEN);
Colorize yellow(String text) => Colorize(text).apply(Styles.LIGHT_YELLOW);
Colorize red(String text) => Colorize(text).apply(Styles.LIGHT_RED);
Colorize bold(String text) => Colorize(text).apply(Styles.BOLD);
