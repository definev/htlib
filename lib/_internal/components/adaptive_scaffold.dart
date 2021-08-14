// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/utils/painter/logo.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/_internal//styled_widget.dart';

part 'adaptive_button.dart';

/// See bottomNavigationBarItem or NavigationRailDestination
class AdaptiveScaffoldDestination {
  final String title;
  final IconData icon;

  const AdaptiveScaffoldDestination({
    required this.title,
    required this.icon,
  });
}

/// A widget that adapts to the current display size, displaying a [Drawer],
/// [NavigationRail], or [BottomNavigationBar]. Navigation destinations are
/// defined in the [destinations] parameter.
class AdaptiveScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final int currentIndex;
  final PageBreak pageBreak;
  final List<AdaptiveScaffoldDestination> destinations;
  final ValueChanged<int>? onNavigationIndexChange;
  final Widget? floatingActionButton;

  AdaptiveScaffold({
    this.appBar,
    this.body,
    required this.currentIndex,
    required this.destinations,
    this.onNavigationIndexChange,
    this.floatingActionButton,
    this.pageBreak = PageBreak.defaultPB,
  });

  @override
  _AdaptiveScaffoldState createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.pageBreak.isDesktop(context)) ...[
          AnimatedContainer(
            duration: Durations.blaze,
            curve: Curves.ease,
            color: Theme.of(context).drawerColor,
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
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: Theme.of(context).textTheme.headline6!.fontSize,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: Insets.m),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (var d in widget.destinations)
                              AdaptiveButton(
                                destination: d,
                                selected: widget.destinations.indexOf(d) == widget.currentIndex,
                                onTap: () => _destinationTapped(d),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        Expanded(
          child: Scaffold(
            appBar: widget.appBar,
            body: Row(
              children: [
                if (widget.pageBreak.isTablet(context)) ...[
                  AnimatedContainer(
                    duration: Durations.medium,
                    height: double.infinity,
                    color: Theme.of(context).dividerColor.withOpacity(0.04),
                    width: 72,
                    child: Column(
                      children: [
                        if (widget.floatingActionButton != null) ...[
                          VSpace(Insets.m - 2),
                          widget.floatingActionButton!,
                        ],
                        for (var d in widget.destinations)
                          AdaptiveButton(
                            destination: d,
                            selected: widget.destinations.indexOf(d) == widget.currentIndex,
                            onTap: () => _destinationTapped(d),
                          )
                      ],
                    ),
                  ),
                ],
                Expanded(child: widget.body!),
              ],
            ),
            floatingActionButton: (widget.pageBreak.isTablet(context))
                ? null
                : widget.pageBreak.isDesktop(context)
                    ? widget.floatingActionButton
                    : widget.floatingActionButton,
            floatingActionButtonLocation: widget.pageBreak.isDesktop(context) ? FloatingActionButtonLocation.endFloat : FloatingActionButtonLocation.startFloat,
            bottomNavigationBar: widget.pageBreak.isMobile(context)
                ? BottomNavigationBar(
                    items: [
                      ...widget.destinations.map(
                        (d) => BottomNavigationBarItem(
                          icon: Icon(d.icon, size: 20.0).padding(bottom: 5),
                          label: d.title,
                        ),
                      ),
                    ],
                    unselectedItemColor: Theme.of(context).disabledColor,
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
      widget.onNavigationIndexChange!(idx);
    }
  }
}
