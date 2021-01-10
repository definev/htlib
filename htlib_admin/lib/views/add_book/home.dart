import 'dart:async';

import 'package:flutter/material.dart';
import 'package:htlib_admin/_internal/utils/utils.dart';
import 'package:htlib_admin/views/add_book/home_view.dart';
import 'package:htlib_admin/views/dashboard/dashboard_page.dart';

enum PageType { None, Dashboard, Setting }

class Home extends StatefulWidget {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  static GlobalKey<DashboardPageState> dashboardPageState = GlobalKey();

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  /// Disable scaffold animations, used when changing pages, so the new page does not animate in
  bool skipScaffoldAnims = false;

  // Avoids a layout error thrown by Flutter when scaffold is forced to close while re-sizing the window
  void closeScaffoldOnResize() {
    if (Home.scaffoldKey.currentState?.isDrawerOpen ?? false) {
      scheduleMicrotask(() => Navigator.pop(context));
    }
  }

  void openMenu() => Home.scaffoldKey.currentState.openDrawer();

  void handleBgTapped() {
    Utils.unFocus();
  }

  @override
  Widget build(BuildContext context) {
    return HomeView(this);
  }
}
