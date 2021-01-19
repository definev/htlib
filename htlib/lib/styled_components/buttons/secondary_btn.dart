import 'package:get/get.dart';
import 'package:htlib/styled_components/buttons/base_styled_button.dart';
import 'package:htlib/styled_components/styled_custom_icon.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:flutter/material.dart';

class SecondaryTextBtn extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const SecondaryTextBtn(this.label, {Key key, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Get.find<Rx<AppTheme>>().value;
    TextStyle txtStyle = TextStyles.Footnote.textColor(theme.accent1Darker);
    return SecondaryBtn(
        onPressed: onPressed, child: Text(label, style: txtStyle));
  }
}

class SecondaryIconBtn extends StatelessWidget {
  /// Must be either an `IconData` for an `ImageIcon` or an `IconData` for a regular `Icon`
  final IconData icon;
  final Function() onPressed;
  final Color color;

  const SecondaryIconBtn(this.icon, {Key key, this.onPressed, this.color})
      : assert((icon is IconData) || (icon is IconData)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Get.find<Rx<AppTheme>>().value;
    return SecondaryBtn(
      onPressed: onPressed,
      minHeight: 36,
      minWidth: 36,
      contentPadding: Insets.sm,
      child: StyledCustomIcon(icon, size: 20, color: color ?? theme.grey),
    );
  }
}

class SecondaryBtn extends StatefulWidget {
  final Widget child;
  final Function() onPressed;
  final double minWidth;
  final double minHeight;
  final double contentPadding;
  final Function(bool) onFocusChanged;

  const SecondaryBtn(
      {Key key,
      this.child,
      this.onPressed,
      this.minWidth,
      this.minHeight,
      this.contentPadding,
      this.onFocusChanged})
      : super(key: key);

  @override
  _SecondaryBtnState createState() => _SecondaryBtnState();
}

class _SecondaryBtnState extends State<SecondaryBtn> {
  bool _isMouseOver = false;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Get.find<Rx<AppTheme>>().value;
    return MouseRegion(
      onEnter: (_) => setState(() => _isMouseOver = true),
      onExit: (_) => setState(() => _isMouseOver = false),
      child: BaseStyledBtn(
        minWidth: widget.minWidth ?? 78,
        minHeight: widget.minHeight ?? 42,
        contentPadding: EdgeInsets.all(widget.contentPadding ?? Insets.m),
        bgColor: theme.surface,
        outlineColor:
            (_isMouseOver ? theme.accent1 : theme.grey).withOpacity(.35),
        hoverColor: theme.surface,
        onFocusChanged: widget.onFocusChanged,
        downColor: theme.greyWeak.withOpacity(.35),
        borderRadius: Corners.s5,
        child: IgnorePointer(child: widget.child),
        onPressed: widget.onPressed,
      ),
    );
  }
}
