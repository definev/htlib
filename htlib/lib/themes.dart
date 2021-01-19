import 'package:htlib/_internal/utils/color_utils.dart';
import 'package:htlib/styled_components/styled_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ThemeType {
  BlueHT,

  GreenMint,
}

class AppTheme {
  final ThemeType themeType;
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
  AppTheme({@required this.isDark, @required this.themeType}) {
    txt = isDark ? Colors.white : Colors.black;
    accentTxt = accentTxt ?? isDark ? Colors.black : Colors.white;
  }

  /// fromType factory constructor
  factory AppTheme.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.GreenMint:
        return AppTheme(isDark: false, themeType: t)
          ..bg1 = Color(0xfff1f7f0)
          ..bg2 = Color(0xffffffff)
          ..surface = Colors.white
          ..accent1 = Color(0xff00a086)
          ..accent1Dark = Color(0xff00856f)
          ..accent1Darker = Color(0xff006b5a)
          ..accent2 = Color(0xff5bc91a)
          ..accent3 = Color(0xfff09433)
          ..greyWeak = Color(0xff909f9c)
          ..grey = Color(0xff515d5a)
          ..greyStrong = Color(0xff151918)
          ..error = Colors.red.shade900
          ..focus = Colors.orange[300];

      case ThemeType.BlueHT:
        return AppTheme(isDark: false, themeType: t)
          ..bg1 = Color(0xfff1f7f0)
          ..bg2 = Color(0xffffffff)
          ..surface = Color(0xFFF3EFF5)
          ..accent1 = Color(0xFF2639E3)
          ..accent1Dark = Color(0xFF192BC2)
          ..accent1Darker = Color(0xFF1523A2)
          ..accent2 = Colors.yellow
          ..accent3 = Colors.yellow[800]
          ..accentTxt = Colors.white
          ..greyWeak = Color(0xff909f9c)
          ..grey = Color(0xff515d5a)
          ..greyStrong = Color(0xff151918)
          ..error = Colors.red.shade900
          ..focus = Color(0xFF0ee2b1);
      default:
        return AppTheme.fromType(ThemeType.GreenMint);
    }
  }

  ThemeData get themeData {
    var t = ThemeData.from(
      textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,
      colorScheme: ColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,
          primary: accent1,
          primaryVariant: accent1Darker,
          secondary: accent1Darker,
          secondaryVariant: ColorUtils.shiftHsl(accent1Darker, -.2),
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
