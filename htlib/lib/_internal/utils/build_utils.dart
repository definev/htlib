import 'package:flutter/material.dart';
import 'package:htlib/styles.dart';
import 'package:get/get.dart';

class BuildUtils {
  static void getFutureSizeFromGlobalKey(
      GlobalKey key, Function(Size size) callback) {
    Future.microtask(() {
      Size size = getSizeFromContext(key.currentContext);
      if (size != null) {
        callback(size);
      }
    });
  }

  static Size getSizeFromContext(BuildContext context) {
    RenderBox rb = context.findRenderObject();
    return rb?.size;
  }

  static Offset getOffsetFromContext(BuildContext context, [Offset offset]) {
    RenderBox rb = context.findRenderObject();
    return rb?.localToGlobal(offset ?? Offset.zero);
  }

  static T getResponsive<T>(BuildContext context,
      {T desktop, T tablet, T mobile}) {
    double size = context.width;
    if (size >= PageBreaks.Desktop) return desktop;
    if (size >= PageBreaks.TabletLandscape) return tablet;
    if (size >= PageBreaks.TabletPortrait) return mobile;
    if (size >= PageBreaks.LargePhone) return mobile;

    return mobile;
  }
}
