import 'package:fast_flutter_driver_tool/src/utils/colorize/src/styles.dart';

class Colorize {
  Colorize(this.initial);

  static const String ESC = '\u{1B}';

  String initial = '';

  void apply(Styles style) {
    initial = _applyStyle(style, initial);
  }

  String buildEscSeq(Styles style) => "$ESC${"[${getStyle(style)}m"}";

  @override
  String toString() => initial;

  String _applyStyle(Styles style, String text) {
    return buildEscSeq(style) + text + buildEscSeq(Styles.RESET);
  }

  static String getStyle(Styles style) {
    switch (style) {
      case Styles.RESET:
        return '0';
      case Styles.BOLD:
        return '1';
      case Styles.DARK:
        return '2';
      case Styles.ITALIC:
        return '3';
      case Styles.UNDERLINE:
        return '4';
      case Styles.BLINK:
        return '5';
      case Styles.REVERSE:
        return '7';
      case Styles.CONCEALED:
        return '8';
      case Styles.DEFAULT:
        return '39';
      case Styles.BLACK:
        return '30';
      case Styles.RED:
        return '31';
      case Styles.GREEN:
        return '32';
      case Styles.YELLOW:
        return '33';
      case Styles.BLUE:
        return '34';
      case Styles.MAGENTA:
        return '35';
      case Styles.CYAN:
        return '36';
      case Styles.LIGHT_GRAY:
        return '37';
      case Styles.DARK_GRAY:
        return '90';
      case Styles.LIGHT_RED:
        return '91';
      case Styles.LIGHT_GREEN:
        return '92';
      case Styles.LIGHT_YELLOW:
        return '93';
      case Styles.LIGHT_BLUE:
        return '94';
      case Styles.LIGHT_MAGENTA:
        return '95';
      case Styles.LIGHT_CYAN:
        return '96';
      case Styles.WHITE:
        return '97';
      case Styles.BG_DEFAULT:
        return '49';
      case Styles.BG_BLACK:
        return '40';
      case Styles.BG_RED:
        return '41';
      case Styles.BG_GREEN:
        return '42';
      case Styles.BG_YELLOW:
        return '43';
      case Styles.BG_BLUE:
        return '44';
      case Styles.BG_MAGENTA:
        return '45';
      case Styles.BG_CYAN:
        return '46';
      case Styles.BG_LIGHT_GRAY:
        return '47';
      case Styles.BG_DARK_GRAY:
        return '100';
      case Styles.BG_LIGHT_RED:
        return '101';
      case Styles.BG_LIGHT_GREEN:
        return '102';
      case Styles.BG_LIGHT_YELLOW:
        return '103';
      case Styles.BG_LIGHT_BLUE:
        return '104';
      case Styles.BG_LIGHT_MAGENTA:
        return '105';
      case Styles.BG_LIGHT_CYAN:
        return '106';
      case Styles.BG_WHITE:
        return '107';
    }
  }
}
