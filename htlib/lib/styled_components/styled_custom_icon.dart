import 'package:htlib/styles.dart';
import 'package:flutter/material.dart';

class StyledCustomIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const StyledCustomIcon(this.icon, {Key key, this.color, this.size})
      : super(key: key);

  @override
  _StyledCustomIconState createState() => _StyledCustomIconState();
}

class _StyledCustomIconState extends State<StyledCustomIcon> {
  Color color;
  Color colorEnd;

  @override
  void initState() {
    super.initState();
    color = widget.color ?? Colors.white;
    colorEnd = color;
  }

  @override
  void didUpdateWidget(covariant StyledCustomIcon oldWidget) {
    if (oldWidget.color != widget.color)
      setState(() {
        color = colorEnd;
        colorEnd = widget.color;
      });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // return TweenAnimationBuilder<Color>(
    //   tween: ColorTween(
    //       begin: color ?? Colors.white, end: colorEnd ?? Colors.white),
    //   duration: Durations.fast,
    //   builder: (context, value, child) =>
    //       Icon(widget.icon, size: widget.size ?? Sizes.iconMed, color: value),
    // );
    return Icon(widget.icon,
        size: widget.size ?? Sizes.iconMed,
        color: widget.color ?? Colors.white);
  }
}
