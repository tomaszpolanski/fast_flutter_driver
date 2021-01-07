part of colorize;

class Colorize {
  static final String ESC = "\u{1B}";

  String initial = '';

  Colorize([this.initial = '']);

  Colorize apply(Styles style, [String text]) {
    if (text == null) {
      text = initial;
    }

    initial = _applyStyle(style, text);
    return this;
  }

  void bgBlack() {
    apply(Styles.BG_BLACK);
  }

  void bgBlue() {
    apply(Styles.BG_BLUE);
  }

  void bgCyan() {
    apply(Styles.BG_CYAN);
  }

  void bgDarkGray() {
    apply(Styles.BG_DARK_GRAY);
  }

  void bgDefault() {
    apply(Styles.BG_DEFAULT);
  }

  void bgGreen() {
    apply(Styles.BG_GREEN);
  }

  void bgLightBlue() {
    apply(Styles.BG_LIGHT_BLUE);
  }

  void bgLightCyan() {
    apply(Styles.BG_LIGHT_CYAN);
  }

  void bgLightGray() {
    apply(Styles.BG_LIGHT_GRAY);
  }

  void bgLightGreen() {
    apply(Styles.BG_LIGHT_GREEN);
  }

  void bgLightMagenta() {
    apply(Styles.BG_LIGHT_MAGENTA);
  }

  void bgLightRed() {
    apply(Styles.BG_LIGHT_RED);
  }

  void bgLightYellow() {
    apply(Styles.BG_LIGHT_YELLOW);
  }

  void bgMagenta() {
    apply(Styles.BG_MAGENTA);
  }

  void bgRed() {
    apply(Styles.BG_RED);
  }

  void bgWhite() {
    apply(Styles.BG_WHITE);
  }

  void bgYellow() {
    apply(Styles.BG_YELLOW);
  }

  void black() {
    apply(Styles.BLACK);
  }

  void blink() {
    apply(Styles.BLINK);
  }

  void blue() {
    apply(Styles.BLUE);
  }

  void bold() {
    apply(Styles.BOLD);
  }

  String buildEscSeq(Styles style) {
    return ESC + "[${getStyle(style)}m";
  }

  Colorize call(String text) {
    initial = text;
    return this;
  }

  void concealed() {
    apply(Styles.CONCEALED);
  }

  void cyan() {
    apply(Styles.CYAN);
  }

  void dark() {
    apply(Styles.DARK);
  }

  void darkGray() {
    apply(Styles.DARK_GRAY);
  }

  void default_slyle() {
    apply(Styles.DEFAULT);
  }

  void green() {
    apply(Styles.GREEN);
  }

  void italic() {
    apply(Styles.ITALIC);
  }

  void lightBlue() {
    apply(Styles.LIGHT_BLUE);
  }

  void lightCyan() {
    apply(Styles.LIGHT_CYAN);
  }

  void lightGray() {
    apply(Styles.LIGHT_GRAY);
  }

  void lightGreen() {
    apply(Styles.LIGHT_GREEN);
  }

  void lightMagenta() {
    apply(Styles.LIGHT_MAGENTA);
  }

  void lightRed() {
    apply(Styles.LIGHT_RED);
  }

  void lightYellow() {
    apply(Styles.LIGHT_YELLOW);
  }

  void magenta() {
    apply(Styles.MAGENTA);
  }

  void red() {
    apply(Styles.RED);
  }

  void reverse() {
    apply(Styles.REVERSE);
  }

  String toString() {
    return initial;
  }

  void underline() {
    apply(Styles.UNDERLINE);
  }

  void white() {
    apply(Styles.WHITE);
  }

  void yellow() {
    apply(Styles.YELLOW);
  }

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
      default: return '';
    }
  }
}
