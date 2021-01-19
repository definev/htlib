import 'package:get/get.dart';
import 'package:htlib/_internal/utils/color_utils.dart';
import 'package:htlib/styled_components/buttons/base_styled_button.dart';
import 'package:htlib/styled_components/styled_custom_icon.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// ////////////////////////////////////////////////////
/// Transparent icon button that changes it's btn color on mouse-over
/// ////////////////////////////////////////////////////
class ColorShiftIconBtn extends StatelessWidget {
  final Function() onPressed;

  final IconData icon;
  final double size;
  final Color color;
  final Color bgColor;
  final EdgeInsets padding;
  final double minWidth;
  final double minHeight;
  final Function(bool) onFocusChanged;
  final bool shrinkWrap;

  const ColorShiftIconBtn(
    this.icon, {
    Key key,
    this.onPressed,
    this.color,
    this.size,
    this.padding,
    this.onFocusChanged,
    this.bgColor,
    this.minWidth,
    this.minHeight,
    this.shrinkWrap = false,
  })  : assert((icon is IconData) || (icon is IconData)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Get.find<Rx<AppTheme>>().value;
    bool _mouseOver = false;
    return StatefulBuilder(
      builder: (_, setState) {
        Color iconColor = (color ?? theme.grey);
        if (_mouseOver) {
          iconColor = ColorUtils.shiftHsl(iconColor, theme.isDark ? .2 : -.2);
        }
        return MouseRegion(
          onEnter: (_) => setState(() => _mouseOver = true),
          onExit: (_) => setState(() => _mouseOver = false),
          child: BaseStyledBtn(
              minHeight: minHeight ?? (shrinkWrap ? 0 : 42),
              minWidth: minWidth ?? (shrinkWrap ? 0 : 42),
              bgColor: bgColor ?? Colors.transparent,
              downColor: theme.bg2.withOpacity(.35),
              hoverColor: bgColor ?? Colors.transparent,
              onFocusChanged: onFocusChanged,
              contentPadding: padding ?? EdgeInsets.all(Insets.sm),
              child: IgnorePointer(
                child: StyledCustomIcon(icon,
                    size: (size ?? 22.0), color: iconColor),
              ),
              onPressed: onPressed),
        );
      },
    );
  }
}
