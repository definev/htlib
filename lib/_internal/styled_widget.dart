import 'package:flutter/material.dart';

extension StyledWidget on Widget {
  Widget padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          top: top ?? vertical ?? all ?? 0.0,
          bottom: bottom ?? vertical ?? all ?? 0.0,
          left: left ?? horizontal ?? all ?? 0.0,
          right: right ?? horizontal ?? all ?? 0.0,
        ),
        child: this,
      );

  Widget constrained({
    double? width,
    double? height,
    double minWidth = 0.0,
    double maxWidth = double.infinity,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
  }) {
    BoxConstraints? constraints = BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
    constraints = (width != null || height != null)
        ? constraints.tighten(width: width, height: height)
        : constraints;
    return ConstrainedBox(
      child: this,
      constraints: constraints,
    );
  }

  Widget expanded({
    int flex = 1,
  }) =>
      Expanded(
        child: this,
        flex: flex,
      );

  Widget flexible({
    int flex = 1,
    FlexFit fit = FlexFit.loose,
  }) =>
      Flexible(
        child: this,
        flex: flex,
        fit: fit,
      );

  Widget center({
    double? widthFactor,
    double? heightFactor,
  }) =>
      Center(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: this,
      );

  Widget clipRRect({
    double? all,
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
    CustomClipper<RRect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
  }) =>
      ClipRRect(
        child: this,
        clipper: clipper ?? null,
        clipBehavior: clipBehavior,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft ?? all ?? 0.0),
          topRight: Radius.circular(topRight ?? all ?? 0.0),
          bottomLeft: Radius.circular(bottomLeft ?? all ?? 0.0),
          bottomRight: Radius.circular(bottomRight ?? all ?? 0.0),
        ),
      );
}
