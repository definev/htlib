import 'package:htlib/styles.dart';
import 'package:flutter/material.dart';

class StyledCustomIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const StyledCustomIcon(this.icon, {Key key, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(icon,
        size: size ?? Sizes.iconMed, color: color ?? Colors.white);
  }
}
