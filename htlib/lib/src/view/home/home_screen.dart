import 'package:animations/animations.dart';
import "package:flutter/material.dart";
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import 'package:htlib/_internal/components/adaptive_scaffold.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/view/book_management/book_management_screen.dart';
import 'package:htlib/src/view/book_management/components/dialog/adding_book_dialog.dart';
import 'package:htlib/src/view/renting_history_management/components/dialog/adding_renting_history_dialog.dart';
import 'package:htlib/src/view/user_management/components/dialog/adding_user_dialog.dart';
import 'package:htlib/src/view/renting_history_management/renting_history_management_screen.dart';
import 'package:htlib/src/view/settings/setting_screen.dart';
import 'package:htlib/src/view/user_management/user_management_screen.dart';
import 'package:htlib/styles.dart';

part 'home_binding.dart';

class HomeScreen extends StatefulWidget {
  static String route = "/";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  BookService bookService;
  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      currentIndex: index,
      destinations: [
        AdaptiveScaffoldDestination(
          title: "Lịch sử mượn",
          icon: Feather.file_text,
        ),
        AdaptiveScaffoldDestination(
          title: "Sách",
          icon: Feather.book_open,
        ),
        AdaptiveScaffoldDestination(
          title: "Người mượn",
          icon: Feather.users,
        ),
        AdaptiveScaffoldDestination(
          title: "Cài đặt",
          icon: Feather.settings,
        ),
      ],
      floatingActionButton: index == 3
          ? null
          : Builder(
              builder: (context) => OpenContainer(
                openColor: Colors.transparent,
                closedColor: Colors.transparent,
                closedElevation: 8.0,
                openBuilder: (context, action) => [
                  AddingRentingHistoryDialog(),
                  AddingBookDialog(),
                  AddingUserDialog(),
                  null,
                ][index],
                closedShape: Theme.of(context).floatingActionButtonTheme.shape,
                closedBuilder: (context, action) => FloatingActionButton(
                  key: ValueKey(index),
                  child: Icon(
                    [
                      Feather.folder_plus,
                      Feather.plus,
                      Feather.user_plus,
                      null
                    ][index],
                    color: Theme.of(context).colorScheme.onPrimary,
                    key: ValueKey(index),
                  ),
                  onPressed: [
                    () {
                      if (GetPlatform.isAndroid) {
                        action();
                      } else {
                        showModal(
                            context: context,
                            builder: (_) => AddingRentingHistoryDialog());
                      }
                    },
                    () {
                      if (GetPlatform.isAndroid) {
                        action();
                      } else {
                        showModal(
                            context: context,
                            builder: (_) => AddingBookDialog());
                      }
                    },
                    () {
                      if (GetPlatform.isAndroid) {
                        action();
                      } else {
                        showModal(
                            context: context,
                            builder: (_) => AddingUserDialog());
                      }
                    },
                    action,
                  ][index],
                ),
              ),
            ),
      onNavigationIndexChange: (value) => setState(() => index = value),
      body: Stack(
        children: [
          if (PageBreak.defaultPB.isDesktop(context))
            Container(
                height: 59.0,
                width: double.infinity,
                color: Theme.of(context).primaryColor),
          PageTransitionSwitcher(
            duration: Durations.medium,
            reverse: true,
            transitionBuilder: (
              Widget child,
              Animation<double> primaryAnimation,
              Animation<double> secondaryAnimation,
            ) =>
                SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
              fillColor: Colors.transparent,
              transitionType: SharedAxisTransitionType.vertical,
            ),
            child: [
              RentingHistoryManagementScreen(),
              BookManagementScreen(),
              UserManagementScreen(),
              SettingScreen(),
            ][index],
          ),
        ],
      ),
    );
  }
}
