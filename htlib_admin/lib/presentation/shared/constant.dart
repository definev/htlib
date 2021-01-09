import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HTlibColorTheme {
  static const Color black = Color(0xFF1C1A1A);
  static const Color white = Color(0xFFFEFEFF);
  static const Color background = Color(0xFFF4F6F3);
  static const Color green = Color(0xFF38A953);
  static const Color mint = Color(0xFFECF8C4);
  static const Color grey = Color(0xFFB6B7B4);
  static const Color iconColor = Color(0xFF979797);

  static ThemeData htlibTheme = ThemeData(
    primaryColor: white,
    accentColor: green,
    textTheme: TextTheme(
      headline6: HTlibTextStyle.headline6Text,
      bodyText1: HTlibTextStyle.normalText,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: iconColor,
    ),
    iconTheme: const IconThemeData(color: iconColor),
  );
}

class HTlibMaterialTextStyle extends MaterialStateProperty<TextStyle> {
  final TextStyle textStyle;

  HTlibMaterialTextStyle(this.textStyle);

  @override
  TextStyle resolve(Set<MaterialState> states) => textStyle;
}

class HTlibFontSize {
  static const double normalFontSize = 14.0;
  static const double titleFontSize = 20.0;
}

class HTlibTextStyle {
  static TextStyle greenButtonText = GoogleFonts.poppins(
    fontSize: HTlibFontSize.normalFontSize,
    color: HTlibColorTheme.white,
  );
  static TextStyle mintButtonText = GoogleFonts.poppins(
    fontSize: HTlibFontSize.normalFontSize,
    color: HTlibColorTheme.green,
  );
  static TextStyle normalText = GoogleFonts.poppins(
    fontSize: HTlibFontSize.normalFontSize,
    color: HTlibColorTheme.black,
  );
  static TextStyle headline6Text = GoogleFonts.poppins(
    fontSize: HTlibFontSize.titleFontSize,
    fontWeight: FontWeight.bold,
    color: HTlibColorTheme.black,
  );
}
