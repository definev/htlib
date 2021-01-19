import 'package:htlib/app_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

export 'package:textstyle_extensions/textstyle_extensions.dart';

class Durations {
  static Duration get fastest => .15.seconds;

  static Duration get fast => .25.seconds;

  static Duration get medium => .35.seconds;

  static Duration get slow => .7.seconds;
}

class Fonts {
  static const String comfortaa = "comfortaa";

  static const String quicksand = "Quicksand";

  static const String emoji = "OpenSansEmoji";
}

class PageBreaks {
  static double get LargePhone => 550;

  static double get TabletPortrait => 768;

  static double get TabletLandscape => 1024;

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

  static double get l => 24 * scale;

  static double get xl => 36 * scale;
}

class FontSizes {
  static double get scale => 1;

  static double get s11 => 11 * scale;

  static double get s12 => 12 * scale;

  static double get s14 => 14 * scale;

  static double get s16 => 16 * scale;

  static double get s18 => 18 * scale;
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
  static const TextStyle comfortaa = TextStyle(
    fontFamily: Fonts.comfortaa,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1,
    fontFamilyFallback: [
      Fonts.emoji,
    ],
  );

  static const TextStyle quicksand = TextStyle(
    fontFamily: Fonts.quicksand,
    fontWeight: FontWeight.w400,
    fontFamilyFallback: [Fonts.emoji],
  );

  static TextStyle get T1 => quicksand.bold
      .size(FontSizes.s14)
      .letterSpace(.7)
      .textColor(Colors.white);
  static Text T1Text(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, T1.copyWith(color: color), key: key);

  static TextStyle get T2 => comfortaa.bold
      .size(FontSizes.s12)
      .letterSpace(.4)
      .textColor(Colors.white);
  static Text T2Text(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, T2.copyWith(color: color), key: key);

  static TextStyle get H1 =>
      comfortaa.bold.size(FontSizes.s14).textColor(Colors.white);
  static Text H1Text(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, H1.copyWith(color: color), key: key);

  static TextStyle get H2 =>
      comfortaa.bold.size(FontSizes.s12).textColor(Colors.white);
  static Text H2Text(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, H1.copyWith(color: color), key: key);

  static TextStyle get Body1 =>
      comfortaa.size(FontSizes.s14).textColor(Colors.white);
  static Text Body1Text(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, Body1.copyWith(color: color), key: key);

  static TextStyle get Body2 =>
      comfortaa.size(FontSizes.s12).textColor(Colors.white);
  static Text Body2Text(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, Body2.copyWith(color: color), key: key);

  static TextStyle get Body3 =>
      comfortaa.size(FontSizes.s11).textColor(Colors.white);
  static Text Body3Text(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, Body3.copyWith(color: color), key: key);

  static TextStyle get Callout =>
      quicksand.size(FontSizes.s14).letterSpace(1.75).textColor(Colors.white);
  static Text CalloutText(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, Callout.copyWith(color: color), key: key);

  static TextStyle get CalloutFocus => Callout.bold;
  static Text CalloutFocusText(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, CalloutFocus.copyWith(color: color),
          key: key);

  static TextStyle get Btn => quicksand.bold
      .size(FontSizes.s14)
      .letterSpace(1.75)
      .textColor(Colors.white);
  static Text BtnText(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, Btn.copyWith(color: color), key: key);

  static TextStyle get BtnSelected =>
      quicksand.size(FontSizes.s14).letterSpace(1.75).textColor(Colors.white);
  static Text BtnSelectedText(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, BtnSelected.copyWith(color: color), key: key);

  static TextStyle get Footnote =>
      quicksand.bold.size(FontSizes.s11).textColor(Colors.white);
  static Text FootnoteText(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, Footnote.copyWith(color: color), key: key);

  static TextStyle get Caption => comfortaa.size(FontSizes.s11).letterSpace(.3);
  static Text CaptionText(String value,
          {TextComponent textComponent = const TextComponent(),
          Color color,
          Key key}) =>
      textComponent.toText(value, Caption.copyWith(color: color), key: key);
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
