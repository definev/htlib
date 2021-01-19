import 'package:flutter/material.dart';

/// An animated sliding container, optimized to hide it's children when closed.
class JustAnimatedPanel extends StatefulWidget {
  final bool isClosed;
  final double closedX;
  final double closedY;
  final double duration;
  final Curve curve;
  final Widget child;

  const JustAnimatedPanel(
      {Key key,
      this.isClosed,
      this.closedX,
      this.closedY,
      this.duration,
      this.curve,
      this.child})
      : super(key: key);

  @override
  _JustAnimatedPanelState createState() => _JustAnimatedPanelState();
}

class _JustAnimatedPanelState extends State<JustAnimatedPanel> {
  bool _isDone = false;

  @override
  Widget build(BuildContext context) {
    Offset closePos = Offset(widget.closedX ?? 0, widget.closedY ?? 0);
    double duration = _isDone && widget.isClosed ? 0 : widget.duration;
    return Container(
      color: Colors.amber,
      child: TweenAnimationBuilder(
        curve: widget.curve ?? Curves.easeOut,
        tween: Tween<Offset>(
          begin: !widget.isClosed ? Offset.zero : closePos,
          end: !widget.isClosed ? Offset.zero : closePos,
        ),
        duration: Duration(milliseconds: (duration * 1000).round()),
        builder: (_, Offset value, Widget c) {
          _isDone = widget.isClosed &&
              value == Offset(widget.closedX, widget.closedY);
          return Transform.translate(offset: value, child: c);
        },
        child: widget.child,
      ),
    );
  }
}

extension AnimatedPanelExtensions on Widget {
  Widget justAnimatedPanelX(
          {double closeX, bool isClosed, double duration = .35, Curve curve}) =>
      justAnimatedPanel(
          closePos: Offset(closeX, 0),
          isClosed: isClosed,
          curve: curve,
          duration: duration);

  Widget justAnimatedPanelY(
          {double closeY, bool isClosed, double duration = .35, Curve curve}) =>
      justAnimatedPanel(
          closePos: Offset(0, closeY),
          isClosed: isClosed,
          curve: curve,
          duration: duration);

  Widget justAnimatedPanel(
      {Offset closePos, bool isClosed, double duration = .35, Curve curve}) {
    return JustAnimatedPanel(
        closedX: closePos.dx,
        closedY: closePos.dy,
        child: this,
        isClosed: isClosed,
        duration: duration,
        curve: curve);
  }
}
