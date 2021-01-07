import 'package:fast_flutter_driver_tool/src/utils/colorize/src/colorize.dart';
import 'package:fast_flutter_driver_tool/src/utils/colorize/src/styles.dart';

void color(
  String text, {
  Styles? front,
  Styles? back,
  bool isUnderline = false,
  bool isBold = false,
  bool isDark = false,
  bool isItalic = false,
  bool isReverse = false,
}) {
  final string = Colorize(text);

  if (front != null) {
    string.apply(front);
  }

  if (back != null) {
    string.apply(back);
  }

  if (isUnderline) {
    string.apply(Styles.UNDERLINE);
  }

  if (isBold) {
    string.apply(Styles.BOLD);
  }

  if (isDark) {
    string.apply(Styles.DARK);
  }

  if (isItalic) {
    string.apply(Styles.ITALIC);
  }

  if (isReverse) {
    string.apply(Styles.REVERSE);
  }

  // ignore: avoid_print
  print(string);
}
