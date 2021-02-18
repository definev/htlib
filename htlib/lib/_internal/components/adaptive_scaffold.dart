// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:htlib/_internal/page_break.dart';

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
  final Widget logo;
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
    this.logo,
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
          Drawer(
            child: Column(
              children: [
                if (widget.logo != null) widget.logo,
                for (var d in widget.destinations)
                  ListTile(
                    leading: Icon(d.icon),
                    title: Text(d.title),
                    selected:
                        widget.destinations.indexOf(d) == widget.currentIndex,
                    onTap: () => _destinationTapped(d),
                  ),
              ],
            ),
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.grey[300],
          ),
        ],
        Expanded(
          child: Scaffold(
            appBar: widget.appBar,
            body: Row(
              children: [
                if (isTablet) ...[
                  NavigationRail(
                    leading: widget.floatingActionButton,
                    destinations: [
                      ...widget.destinations.map(
                        (d) => NavigationRailDestination(
                          icon: Icon(d.icon),
                          label: Text(d.title),
                        ),
                      ),
                    ],
                    selectedIndex: widget.currentIndex,
                    onDestinationSelected:
                        widget.onNavigationIndexChange ?? (_) {},
                  ),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ],
                Expanded(child: widget.body),
              ],
            ),
            floatingActionButton:
                (isTablet) ? null : widget.floatingActionButton,
            bottomNavigationBar: (isMobile)
                ? BottomNavigationBar(
                    elevation: 20,
                    // unselectedIconTheme:
                    //     IconThemeData(color: Colors.black38, size: 20),
                    // unselectedLabelStyle: TextStyle(color: Colors.black38),
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
