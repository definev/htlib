import 'package:htlib_admin/_internal/utils/color_utils.dart';
import 'package:htlib_admin/data/theme/theme_type.dart';
import 'package:htlib_admin/styled_components/styled_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeType defaultTheme = ThemeType.BlueHT;

  bool isDark;
  Color bg1; //
  Color surface; //
  Color bg2;
  Color accent1;
  Color accent1Dark;
  Color accent1Darker;
  Color accent2;
  Color accent3;
  Color grey;
  Color greyStrong;
  Color greyWeak;
  Color error;
  Color focus;

  Color txt;
  Color accentTxt;

  /// Default constructor
  AppTheme({@required this.isDark}) {
    txt = isDark ? Colors.white : Colors.black;
    accentTxt = accentTxt ?? isDark ? Colors.black : Colors.white;
  }

  /// fromType factory constructor
  factory AppTheme.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.BlueHT:
        return AppTheme(isDark: false)
          ..bg1 = Color(0xfff1f7f0)
          ..bg2 = Color(0xffc1dcbc)
          ..surface = Colors.white
          ..accent1 = Colors.blueAccent
          ..accent1Dark = Color(0xFF2979FF)
          ..accent1Darker = Color(0xFF2962FF)
          ..accent2 = Color(0xfff09433)
          ..accent3 = Color(0xff5bc91a)
          ..greyWeak = Color(0xff909f9c)
          ..grey = Color(0xff515d5a)
          ..greyStrong = Color(0xff151918)
          ..error = Colors.red.shade900
          ..focus = Color(0xFF82B1FF);

      case ThemeType.BlueHT_Dark:
        return AppTheme(isDark: true)
          ..bg1 = Color(0xff121212)
          ..bg2 = Color(0xff2c2c2c)
          ..surface = Color(0xff252525)
          ..accent1 = Color(0xff00a086)
          ..accent1Dark = Color(0xff00caa5)
          ..accent1Darker = Color(0xff00caa5)
          ..accent2 = Color(0xfff19e46)
          ..accent3 = Color(0xff5BC91A)
          ..greyWeak = Color(0xffa8b3b0)
          ..grey = Color(0xffced4d3)
          ..greyStrong = Color(0xffffffff)
          ..error = Color(0xffe55642)
          ..focus = Color(0xff0ee2b1);
      default:
        return AppTheme.fromType(defaultTheme);
    }
  }

  ThemeData get themeData {
    var t = ThemeData.from(
      textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,
      colorScheme: ColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,
          primary: accent1,
          primaryVariant: accent1Darker,
          secondary: accent2,
          secondaryVariant: ColorUtils.shiftHsl(accent2, -.2),
          background: bg1,
          surface: surface,
          onBackground: txt,
          onSurface: txt,
          onError: txt,
          onPrimary: accentTxt,
          onSecondary: accentTxt,
          error: error ?? Colors.red.shade400),
    );
    return t.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: ThinUnderlineBorder(),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: greyWeak,
          selectionHandleColor: Colors.transparent,
          cursorColor: accent1,
        ),
        buttonColor: accent1,
        highlightColor: accent1,
        toggleableActiveColor: accent1);
  }

  Color shift(Color c, double d) =>
      ColorUtils.shiftHsl(c, d * (isDark ? -1 : 1));
}
