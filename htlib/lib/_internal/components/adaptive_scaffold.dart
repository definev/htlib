// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/utils/painter/logo.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

part 'adaptive_button.dart';

/// See bottomNavigationBarItem or NavigationRailDestination
class AdaptiveScaffoldDestination {
  final String title;
  final IconData icon;

  const AdaptiveScaffoldDestination({
    @required this.title,
    @required this.icon,
  });
}

/// A widget that adapts to the current display size, displaying a [Drawer],
/// [NavigationRail], or [BottomNavigationBar]. Navigation destinations are
/// defined in the [destinations] parameter.
class AdaptiveScaffold extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final Widget body;
  final int currentIndex;
  final PageBreak pageBreak;
  final List<AdaptiveScaffoldDestination> destinations;
  final ValueChanged<int> onNavigationIndexChange;
  final Widget floatingActionButton;

  AdaptiveScaffold({
    this.appBar,
    this.body,
    @required this.currentIndex,
    @required this.destinations,
    this.onNavigationIndexChange,
    this.floatingActionButton,
    this.pageBreak = PageBreak.defaultPB,
  });

  @override
  _AdaptiveScaffoldState createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  bool get isDesktop =>
      MediaQuery.of(context).size.width >= widget.pageBreak.desktop;

  bool get isTablet =>
      MediaQuery.of(context).size.width >= widget.pageBreak.tablet &&
      !isDesktop;

  bool get isMobile =>
      MediaQuery.of(context).size.width < widget.pageBreak.tablet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isDesktop) ...[
          SizedBox(
            width: 304.0,
            child: Column(
              children: [
                Container(
                  height: 59.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2.0,
                        spreadRadius: 2.0,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Logo(size: 43.0).padding(
                        left: Insets.m,
                        right: Insets.l,
                      ),
                      Text(
                        AppConfig.title,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                for (var d in widget.destinations)
                  AdaptiveButton(
                    destination: d,
                    selected:
                        widget.destinations.indexOf(d) == widget.currentIndex,
                    onTap: () => _destinationTapped(d),
                  )
              ],
            ),
          )
              .animate(Durations.medium, Curves.decelerate)
              .backgroundColor(Theme.of(context).drawerColor),
        ],
        Expanded(
          child: Scaffold(
            appBar: widget.appBar,
            body: Row(
              children: [
                if (isTablet) ...[
                  AnimatedContainer(
                    duration: Durations.medium,
                    height: double.infinity,
                    color: Theme.of(context).dividerColor.withOpacity(0.04),
                    width: 72,
                    child: Column(
                      children: [
                        if (widget.floatingActionButton != null) ...[
                          VSpace(Insets.m - 2),
                          widget.floatingActionButton,
                        ],
                        for (var d in widget.destinations)
                          AdaptiveButton(
                            destination: d,
                            selected: widget.destinations.indexOf(d) ==
                                widget.currentIndex,
                            onTap: () => _destinationTapped(d),
                          )
                      ],
                    ),
                  ),
                ],
                Expanded(child: widget.body),
              ],
            ),
            floatingActionButton:
                (isTablet) ? null : widget.floatingActionButton,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: (isMobile)
                ? BottomNavigationBar(
                    elevation: 20,
                    items: [
                      ...widget.destinations.map(
                        (d) => BottomNavigationBarItem(
                          icon: Icon(d.icon),
                          label: d.title,
                        ),
                      ),
                    ],
                    currentIndex: widget.currentIndex,
                    onTap: widget.onNavigationIndexChange,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  void _destinationTapped(AdaptiveScaffoldDestination destination) {
    var idx = widget.destinations.indexOf(destination);
    if (idx != widget.currentIndex) {
      widget.onNavigationIndexChange(idx);
    }
  }
}
