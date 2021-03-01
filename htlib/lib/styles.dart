import 'package:google_fonts/google_fonts.dart';
import 'package:time/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

export 'package:textstyle_extensions/textstyle_extensions.dart';

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
  static Duration get blaze => .05.seconds;

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

  static double get s28 => 28 * scale;
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

class TextComponent {
  /// The text to display as a [InlineSpan].
  ///
  /// This will be null if [data] is provided instead.
  final InlineSpan textSpan;

  /// If non-null, the style to use for this text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [data] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  final TextDirection textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale locale;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  ///
  /// Defaults to retrieving the value from the nearest [DefaultTextStyle] ancestor.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  ///
  /// The value given to the constructor as textScaleFactor. If null, will
  /// use the [MediaQueryData.textScaleFactor] obtained from the ambient
  /// [MediaQuery], or 1.0 if there is no [MediaQuery] in scope.
  final double textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int maxLines;

  /// An alternative semantics label for this text.
  ///
  /// If present, the semantics of this widget will contain this value instead
  /// of the actual text. This will overwrite any of the semantics labels applied
  /// directly to the [TextSpan]s.
  ///
  /// This is useful for replacing abbreviations or shorthands with the full
  /// text value:
  ///
  /// ```dart
  /// Text(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  final String semanticsLabel;

  const TextComponent({
    this.textSpan,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  });

  Text toText(String value, TextStyle textStyle, {Key key}) => Text(
        value,
        locale: locale,
        maxLines: maxLines,
        overflow: overflow,
        semanticsLabel: semanticsLabel,
        softWrap: softWrap,
        strutStyle: strutStyle,
        style: textStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        textScaleFactor: textScaleFactor,
      );
}

class TextStyles {
  static TextStyle get comfortaa => TextStyle(
        fontFamily: "comfortaa",
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1,
        decoration: TextDecoration.none,
      );

  static TextStyle get hapna => TextStyle(
        fontFamily: "Hapna",
        fontWeight: FontWeight.w100,
        decoration: TextDecoration.none,
      );

  static TextStyle get fraunces => GoogleFonts.alike(
        decoration: TextDecoration.none,
      );

  static TextStyle get Heading5 => fraunces.bold
      .size(FontSizes.s28)
      .letterSpace(.4)
      .textHeight(1.34)
      .copyWith(fontWeight: FontWeight.w700);

  static TextStyle get Heading6 =>
      hapna.bold.size(FontSizes.s20).letterSpace(.7);

  static TextStyle get Subtitle1 =>
      hapna.bold.size(FontSizes.s16).letterSpace(.5);

  static TextStyle get Subtitle2 =>
      hapna.bold.size(FontSizes.s14).letterSpace(.1);

  static TextStyle get Body1 => comfortaa.size(FontSizes.s14);
  static Text Body1Text(String value,
          {TextComponent textComponent =
              const TextComponent(overflow: TextOverflow.ellipsis),
          Color color,
          Key key}) =>
      textComponent.toText(value, Body1.copyWith(color: color), key: key);

  static TextStyle get Body2 => comfortaa.letterSpace(.1).size(FontSizes.s12);
  static Text Body2Text(String value,
          {TextComponent textComponent =
              const TextComponent(overflow: TextOverflow.ellipsis),
          Color color,
          Key key}) =>
      textComponent.toText(value, Body2.copyWith(color: color), key: key);
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
