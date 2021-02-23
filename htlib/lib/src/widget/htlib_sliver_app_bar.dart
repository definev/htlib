import 'package:flutter/material.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/utils/painter/logo.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

class HtlibSliverAppBar extends StatefulWidget {
  final String title;
  final List<Widget> actions;
  final Widget bottom;

  const HtlibSliverAppBar(
      {Key key, this.actions, @required this.bottom, @required this.title})
      : super(key: key);

  @override
  _HtlibSliverAppBarState createState() => _HtlibSliverAppBarState();
}

class _HtlibSliverAppBarState extends State<HtlibSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 3,
      forceElevated: false,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedContainer(
          duration: Durations.fast,
          curve: Curves.decelerate,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark,
              ],
            ),
          ),
        ),
        stretchModes: [StretchMode.fadeTitle, StretchMode.zoomBackground],
        title: !PageBreak.defaultPB.isDesktop(context)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(
                    constrainChild: Image.asset("assets/images/HT-logo.png")
                        .constrained(height: 60.0)
                        .opacity(0.0),
                  ),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ).padding(right: Insets.m),
                ],
              )
            : null,
        titlePadding: EdgeInsets.only(top: 12, bottom: 72, left: Insets.m),
      ),
      leadingWidth: 124.0,
      actions:
          (!PageBreak.defaultPB.isDesktop(context)) ? null : widget.actions,
      bottom: PageBreak.defaultPB.isDesktop(context) ? null : widget.bottom,
      collapsedHeight: PageBreak.defaultPB.isDesktop(context)
          ? 59.0
          : 60 - Insets.xs + Insets.m + 7,
      expandedHeight: PageBreak.defaultPB.isDesktop(context)
          ? 59.0
          : 56 + 3 * (60 - Insets.xs) + 4 * Insets.m,
      centerTitle: true,
      pinned: true,
      floating: true,
    );
  }
}
