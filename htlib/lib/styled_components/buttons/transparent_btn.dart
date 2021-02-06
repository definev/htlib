import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/color_utils.dart';
import 'package:htlib/styled_components/buttons/base_styled_button.dart';
import 'package:htlib/styled_components/styled_custom_icon.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:flutter/material.dart';

class TransparentBtn extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  final bool bigMode;
  final EdgeInsets contentPadding;
  final Color bgColor;
  final Color hoverColor;
  final Color downColor;
  final double borderRadius;

  const TransparentBtn(
      {Key key,
      this.onPressed,
      this.child,
      this.bigMode = false,
      this.contentPadding,
      this.bgColor,
      this.hoverColor,
      this.downColor,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Get.find<Rx<AppTheme>>().value;
    return BaseStyledBtn(
      minWidth: 30,
      minHeight: 30,
      contentPadding: contentPadding ??
          EdgeInsets.symmetric(
            horizontal: bigMode ? Insets.sm : Insets.xs,
            vertical: bigMode ? Insets.sm : Insets.xs,
          ),
      bgColor: bgColor ?? Colors.transparent,
      hoverColor: hoverColor ??
          (theme.isDark
              ? ColorUtils.shiftHsl(theme.bg1, .2)
              : theme.bg2.withOpacity(.35)),
      downColor: downColor ?? ColorUtils.shiftHsl(theme.bg2, .1),
      borderRadius: borderRadius ?? Corners.s5Border,
      child: child,
      onPressed: onPressed,
    );
  }
}

class TransparentTextBtn extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Color color;
  final bool bigMode;
  final TextStyle style;
  final Color bgColor;

  const TransparentTextBtn(this.label,
      {Key key,
      this.onPressed,
      this.color,
      this.bigMode = false,
      this.style,
      this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Get.find<Rx<AppTheme>>().value;
    Color c = color ?? theme.accent1;
    return TransparentBtn(
      bigMode: bigMode,
      bgColor: bgColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: style ??
                  (bigMode ? TextStyles.Body1 : TextStyles.T1).textColor(c))
        ],
      ),
      onPressed: onPressed,
    );
  }
}

class TransparentIconAndTextBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final double iconSize;
  final Function() onPressed;
  final Color color;
  final Color textColor;
  final bool bigMode;
  final TextStyle style;

  const TransparentIconAndTextBtn(this.label, this.icon,
      {Key key,
      this.onPressed,
      this.color,
      this.textColor,
      this.bigMode = false,
      this.iconSize,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Get.find<Rx<AppTheme>>().value;
    Color c = color ?? theme.accent1;
    return TransparentBtn(
      bigMode: bigMode,
      child: Row(
        children: [
          StyledCustomIcon(icon, size: iconSize ?? 16, color: c),
          HSpace(Insets.sm),
          Text(label,
              style: style ?? TextStyles.Body1.textColor(textColor ?? c)),
          HSpace(
              3), // Add a bit of extra padding to the right, seems like Icon() has it's own baked in padding
        ],
      ),
      onPressed: onPressed,
    );
  }
}
