import 'package:flutter/cupertino.dart';

class ColorUtils {
  static Color shiftHsl(Color c, [double amt = 0]) {
    var hslc = HSLColor.fromColor(c);
    return hslc.withLightness(hslc.lightness + amt).toColor();
  }

  static Color parseHex(String value) =>
      Color(int.parse(value.substring(1, 7), radix: 16) + 0xFF000000);

  static Color blend(Color dst, Color src, double opacity) {
    getColorValue(int dst, int src) => (dst * (1.0 - opacity) + src).toInt();

    return Color.fromARGB(
      255,
      getColorValue(dst.red, src.red),
      getColorValue(dst.green, src.green),
      getColorValue(dst.blue, src.blue),
    );
  }
}
