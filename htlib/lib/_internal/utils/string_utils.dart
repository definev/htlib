import 'dart:ui';

import 'package:flutter/material.dart';

class StringUtils {
  /// Calculate size of text widget
  static Size measure(String text, TextStyle style,
      {int maxLines: 1, TextDirection direction = TextDirection.ltr}) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: maxLines,
        textDirection: direction)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static double measureLongest(List<String> items, TextStyle style,
      [int maxItems]) {
    double l = 0;
    if (maxItems != null && maxItems < items.length) {
      items.length = maxItems;
    }
    for (var item in items) {
      double m = StringUtils.measure(item, style).width;
      if (m > l) l = m;
    }
    return l;
  }

  static String moneyFormat(int value, {String prefix}) {
    String valueStr = "$value";
    String res = "";

    /// [100,000]

    for (var i = valueStr.length - 1; i >= 0; i--) {
      String digit = "";
      if (i == 0) {
        digit = "${valueStr[i]}";
      } else if ((valueStr.length - i) % 3 == 0) {
        digit = "${valueStr[i]},";
      } else {
        digit = "${valueStr[i]}";
      }
      res += "$digit";
    }

    valueStr = res;
    res = "";

    for (var i = valueStr.length - 1; i >= 0; i--) {
      res += valueStr[i];
    }

    prefix != null ? prefix = " " + prefix : prefix = "";

    return res + prefix;
  }
}
