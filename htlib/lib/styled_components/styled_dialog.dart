import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/globals.dart';
import 'package:htlib/styled_components/buttons/ok_cancel_btn_row.dart';
import 'package:htlib/styled_components/scrolling/styled_listview.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static Future<dynamic> show(Widget child, [BuildContext context]) async {
    return await (context != null ? Navigator.of(context) : AppGlobals.nav)
        .push(
      StyledDialogRoute(
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SafeArea(child: child);
        },
      ),
    );
    /*return await showDialog(
      context: context ?? MainViewContext.value,
      builder: (context) => child,
    );*/
  }
}

class StyledDialog extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final double maxHeight;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final Color bgColor;
  final double elevation;
  final bool shrinkWrap;

  const StyledDialog({
    Key key,
    this.child,
    this.maxWidth,
    this.maxHeight,
    this.padding,
    this.margin,
    this.bgColor,
    this.borderRadius,
    this.elevation,
    this.shrinkWrap = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius radius = borderRadius ?? Corners.s8Border;
    AppTheme theme = Get.find<Rx<AppTheme>>().value;

    Widget innerContent = Container(
      padding: padding ?? EdgeInsets.all(Insets.lGutter),
      color: bgColor ?? theme.surface,
      //elevation: elevation ?? dialogTheme.elevation ?? 3,
      child: child,
    );

    if (shrinkWrap) {
      innerContent =
          IntrinsicWidth(child: IntrinsicHeight(child: innerContent));
    }

    return FocusTraversalGroup(
      child: Container(
        margin: margin ?? EdgeInsets.all(Insets.lGutter * 2),
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 280.0,
            maxHeight: maxHeight ?? double.infinity,
            maxWidth: maxWidth ?? double.infinity,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: SingleChildScrollView(
              physics: StyledScrollPhysics(),
              child: Material(
                  type: MaterialType.transparency, child: innerContent),
            ),
          ),
        ),
      ),
    );
  }
}

class OkCancelDialog extends StatelessWidget {
  final Function() onOkPressed;
  final Function() onCancelPressed;
  final String okLabel;
  final String cancelLabel;
  final String title;
  final String message;
  final double maxWidth;

  const OkCancelDialog(
      {Key key,
      this.onOkPressed,
      this.onCancelPressed,
      this.okLabel,
      this.cancelLabel,
      this.title,
      this.message,
      this.maxWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Get.find<Rx<AppTheme>>().value;
    return StyledDialog(
      maxWidth: maxWidth ?? 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null) ...[
            Text(title.toUpperCase(),
                style: TextStyles.T1.textColor(theme.accent1Darker)),
            VSpace(Insets.sm * 1.5),
            Container(color: theme.greyWeak.withOpacity(.35), height: 1),
            VSpace(Insets.m * 1.5),
          ],
          Text(message, style: TextStyles.Body1.textHeight(1.5)),
          SizedBox(height: Insets.l),
          OkCancelBtnRow(
            onOkPressed: onOkPressed,
            onCancelPressed: onCancelPressed,
            okLabel: okLabel?.toUpperCase(),
            cancelLabel: cancelLabel?.toUpperCase(),
          )
        ],
      ),
    );
  }
}

class StyledDialogRoute<T> extends PopupRoute<T> {
  StyledDialogRoute({
    @required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    String barrierLabel,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder transitionBuilder,
    RouteSettings settings,
  })  : assert(barrierDismissible != null),
        _pageBuilder = pageBuilder,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        _transitionBuilder = transitionBuilder,
        super(settings: settings);

  final RoutePageBuilder _pageBuilder;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String get barrierLabel => _barrierLabel;
  final String _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  final RouteTransitionsBuilder _transitionBuilder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
      child: _pageBuilder(context, animation, secondaryAnimation),
      scopesRoute: true,
      explicitChildNodes: true,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (_transitionBuilder == null) {
      return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.linear),
          child: child);
    } // Some default transition
    return _transitionBuilder(context, animation, secondaryAnimation, child);
  }
}
