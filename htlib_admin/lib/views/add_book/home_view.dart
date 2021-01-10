import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:htlib_admin/views/add_book/nav_side_menu.dart';
import 'package:provider/provider.dart';
import 'package:htlib_admin/_internal/widget_view.dart';
import 'package:htlib_admin/app_extensions.dart';
import 'package:htlib_admin/styles.dart';
import 'package:htlib_admin/themes.dart';
import 'package:htlib_admin/views/add_book/home.dart';
import 'package:tuple/tuple.dart';

class HomeView extends WidgetView<Home, HomeState> {
  HomeView(HomeState state) : super(state);

  Tuple2<double, bool> calculateLeftMenu(BuildContext context) {
    double leftMenuWidth = Sizes.sideBarSm;
    bool skinnyMenuMode = true;
    if (context.widthPx >= PageBreaks.Desktop) {
      leftMenuWidth = Sizes.sideBarLg;
      skinnyMenuMode = false;
    } else if (context.widthPx > PageBreaks.TabletLandscape) {
      leftMenuWidth = Sizes.sideBarMed;
    }

    return Tuple2(leftMenuWidth, skinnyMenuMode);
  }

  @override
  Widget build(BuildContext context) {
    state.closeScaffoldOnResize();

    /// ----------------------`RESPONSIVE LAYOUT LOGIC`--------------------- ///

    /// Calculate [Left Menu] Size
    double leftMenuWidth = calculateLeftMenu(context).item1;
    bool skinnyMenuMode = calculateLeftMenu(context).item2;

    /// Calculate [Right Panel] Size
    double rightPanelWidth = 400;
    if (context.widthInches > 8.0) {
      //Panel size gets a little bigger as the screen size grows
      rightPanelWidth += (context.widthInches - 8) * 12;
    }

    bool isNarrow = context.widthPx < PageBreaks.TabletPortrait;

    /// Calculate Top bar height
    double topBarHeight = 60;
    double topBarPadding = isNarrow ? Insets.m : Insets.l;

    /// `Figure out what should be visible, and the size of our viewport`
    /// 3 cases:
    /// 1)    [Single Column]
    /// 2)    [LeftMenu + Single Column]
    /// 3)    [LeftMenu + Dual Column]
    /// Note: [Dual Column means it can show both ContentArea and EditPanel at the same time]

    /// Is panel show?
    bool showPanel;

    /// Show left menu whatever [size] except [PageBreaks.TabletPortrait]
    bool showLeftMenu = !isNarrow;

    /// [SingleColumn] mean not showing [RightPanel]
    bool useSingleColumn = context.widthInches < 10;

    /// If [SingleColumn + RightPanel == DualColumn], we can hide the content
    bool hideContent = showPanel && useSingleColumn;

    /// Left position for the main content stack
    double leftContentOffset = showLeftMenu ? leftMenuWidth : Insets.mGutter;

    /// Right position for main content stack
    double contentRightPos = showPanel ? rightPanelWidth : 0;

    Duration animDuration = state.skipScaffoldAnims ? .01.seconds : .35.seconds;

    /// Reset flag so we only skip animations for one build cycle
    state.skipScaffoldAnims = false;

    /// ----------------------`RESPONSIVE LAYOUT LOGIC`--------------------- ///

    /// ----------------------`BUILD`--------------------- ///

    AppTheme appTheme = context.watch();
    return Scaffold(
      key: Home.scaffoldKey,
      drawer: showLeftMenu ? null : NavSideMenu(),
      body: Stack(
        children: [],
      ),
    );
  }
}
