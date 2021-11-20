import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class ColorUtils {
  static Color shiftHsl(Color c, [double amt = 0]) {
    var hslc = HSLColor.fromColor(c);
    return hslc.withLightness(hslc.lightness + amt).toColor();
  }

  static Color parseHex(String value) =>
      Color(int.parse(value.substring(1, 7), radix: 16) + 0xFF000000);

  static PdfColor toPdfColor(Color color) {
    var hex = color.toHex();
    return PdfColor.fromHex(hex);
  }

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
