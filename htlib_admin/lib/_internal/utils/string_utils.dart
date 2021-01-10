import 'dart:ui';

import 'package:flutter/material.dart';

class StringUtils {
  static bool isEmpty(String s) {
    return s == null || s.trim().isEmpty;
  }

  static bool isNotEmpty(String s) => !isEmpty(s);

  static bool isEmailValid(String value) {
    if (StringUtils.isEmpty(value)) return false;
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

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

  /// Prevent null string
  static String safeGet(String value, [String suffix]) {
    return (value ?? "") + (StringUtils.isNotEmpty(value) ? suffix ?? "" : "");
  }
}
