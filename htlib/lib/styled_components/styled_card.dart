import 'package:get/get.dart';
import 'package:htlib/styled_components/buttons/transparent_btn.dart';
import 'package:htlib/styled_components/styled_container.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:flutter/material.dart';

/// A card that defaults to theme.surface1, and has a built in shadow and rounded corners.
class StyledCard extends StatelessWidget {
  final Color bgColor;
  final bool enableShadow;
  final Widget child;
  final Function() onPressed;
  final Alignment align;

  const StyledCard(
      {Key key,
      this.bgColor,
      this.enableShadow = true,
      this.child,
      this.onPressed,
      this.align})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Get.find<Rx<AppTheme>>().value;
    Color c = bgColor ?? theme.surface;

    Widget content = StyledContainer(c,
        align: align,
        child: child,
        borderRadius: Corners.s8Border,
        shadows: enableShadow ? Shadows.m(theme.accent1Darker) : null);

    if (onPressed != null)
      return TransparentBtn(child: content, onPressed: onPressed);
    return content;
  }
}
