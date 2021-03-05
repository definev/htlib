import 'package:google_fonts/google_fonts.dart';
import 'package:time/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

export 'package:textstyle_extensions/textstyle_extensions.dart';

enum ChildLayoutMode { list, grid }

extension HtlibTheme on ThemeData {
  Color get tileColor => this.brightness == Brightness.light
      ? Color.lerp(Colors.white, this.colorScheme.primary, 0.01)
      : Color.lerp(
          this.backgroundColor,
          this.primaryColor,
          .01,
        );

  Color get drawerColor => this.brightness == Brightness.light
      ? Color.lerp(Colors.white, this.dividerColor, .03)
      : Color.lerp(Colors.black, this.dividerColor, .03);
}

class Durations {
  static Duration get blaze => .1.seconds;

  static Duration get fastest => .15.seconds;

  static Duration get fast => .25.seconds;

  static Duration get medium => .35.seconds;

  static Duration get slow => .7.seconds;
}

class PageBreaks {
  static double get LargePhone => 550;

  static double get TabletPortrait => 768;

  static double get TabletLandscape => 1280;

  static double get Desktop => 1440;
}

class Insets {
  static double gutterScale = 1;

  static double scale = 1;

  /// Dynamic insets, may get scaled with the device size
  static double get mGutter => m * gutterScale;

  static double get lGutter => l * gutterScale;

  static double get xs => 2 * scale;

  static double get sm => 6 * scale;

  static double get m => 12 * scale;

  static double get mid => 18 * scale;

  static double get l => 24 * scale;

  static double get xl => 36 * scale;
}

class FontSizes {
  static double get scale => 1;

  static double get s11 => 11 * scale;

  static double get s12 => 12 * scale;

  static double get s14 => 14 * scale;

  static double get s16 => 16 * scale;

  static double get s20 => 20 * scale;

  static double get s24 => 34 * scale;

  static double get s34 => 34 * scale;
}

class Sizes {
  static double hitScale = 1;

  static double get hit => 40 * hitScale;

  static double get iconSm => 15;

  static double get iconMed => 20;

  static double get sideBarSm => 150 * hitScale;

  static double get sideBarMed => 200 * hitScale;

  static double get sideBarLg => 290 * hitScale;
}

class TextStyles {
  static TextStyle get comfortaa => GoogleFonts.spaceMono(
        // fontFamily: "comfortaa",
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1,
        decoration: TextDecoration.none,
      );

  static TextStyle get hapna => GoogleFonts.trirong(
        // fontFamily: "Hapna",
        fontWeight: FontWeight.w300,
        decoration: TextDecoration.none,
      );

  static TextStyle get fraunces => GoogleFonts.lobster(
        // fontFamily: "Hapna",
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.none,
      );

  static TextStyle get Headline4 =>
      fraunces.bold.size(FontSizes.s34).letterSpace(.25);

  static TextStyle get Headline5 => fraunces.bold
      .size(FontSizes.s24)
      .letterSpace(.4)
      .textHeight(1.34)
      .copyWith(fontWeight: FontWeight.w700);

  static TextStyle get Headline6 =>
      fraunces.bold.size(FontSizes.s20).letterSpace(.7);

  static TextStyle get Subtitle1 =>
      hapna.bold.size(FontSizes.s16).letterSpace(.15);

  static TextStyle get Subtitle2 =>
      hapna.bold.size(FontSizes.s14).letterSpace(.1);

  static TextStyle get Body1 => comfortaa.size(FontSizes.s14);

  static TextStyle get Body2 => comfortaa.letterSpace(.1).size(FontSizes.s12);

  static TextStyle get Button => comfortaa.letterSpace(.1).size(FontSizes.s14);
}

class Shadows {
  static bool enabled = true;

  static double get mRadius => 8;

  static List<BoxShadow> m(Color color, [double opacity = 0]) {
    return enabled
        ? [
            BoxShadow(
              color: color.withOpacity(opacity ?? .03),
              blurRadius: mRadius,
              spreadRadius: mRadius / 2,
              offset: Offset(1, 0),
            ),
            BoxShadow(
              color: color.withOpacity(opacity ?? .04),
              blurRadius: mRadius / 2,
              spreadRadius: mRadius / 4,
              offset: Offset(1, 0),
            )
          ]
        : null;
  }
}

class Corners {
  static double get btn => s5;

  static double get dialog => 12;

  /// Xs
  static double get s3 => 3;

  static BorderRadius get s3Border => BorderRadius.all(s3Radius);

  static Radius get s3Radius => Radius.circular(s3);

  /// Small
  static double get s5 => 5;

  static BorderRadius get s5Border => BorderRadius.all(s5Radius);

  static Radius get s5Radius => Radius.circular(s5);

  /// Medium
  static double get s8 => 8;

  static BorderRadius get s8Border => BorderRadius.all(s8Radius);

  static Radius get s8Radius => Radius.circular(s8);

  /// Large
  static double get s10 => 10;

  static BorderRadius get s10Border => BorderRadius.all(s10Radius);

  static Radius get s10Radius => Radius.circular(s10);
}
