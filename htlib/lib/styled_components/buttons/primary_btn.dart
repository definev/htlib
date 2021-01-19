import 'package:get/get.dart';
import 'package:htlib/styled_components/buttons/base_styled_button.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:flutter/material.dart';

class PrimaryBtn extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  final bool bigMode;
  final Color bgColor;
  final Color hoverColor;
  final Color downColor;

  const PrimaryBtn(
      {Key key,
      this.child,
      this.onPressed,
      this.bigMode = false,
      this.bgColor,
      this.hoverColor,
      this.downColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Get.find<Rx<AppTheme>>().value;
    return BaseStyledBtn(
      minWidth: bigMode ? 160 : 78,
      minHeight: bigMode ? 60 : 42,
      contentPadding: EdgeInsets.all(bigMode ? Insets.l : Insets.m),
      bgColor: bgColor ?? theme.accent1Darker,
      hoverColor:
          hoverColor ?? (theme.isDark ? theme.accent1 : theme.accent1Dark),
      downColor: downColor ?? theme.accent1Darker,
      borderRadius: bigMode ? Corners.s8 : Corners.s5,
      child: child,
      onPressed: onPressed,
    );
  }
}

class PrimaryTextBtn extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final bool bigMode;

  const PrimaryTextBtn(this.label,
      {Key key, this.onPressed, this.bigMode = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle txtStyle = (bigMode ? TextStyles.Callout : TextStyles.Footnote)
        .textColor(Colors.white);
    return PrimaryBtn(
        bigMode: bigMode,
        onPressed: onPressed,
        child: Text(label, style: txtStyle));
  }
}
