import 'package:animations/animations.dart';
import "package:flutter/material.dart";
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import 'package:htlib/_internal/components/adaptive_scaffold.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/view/book_management/book_management_screen.dart';
import 'package:htlib/src/view/book_management/components/dialog/adding_book_dialog.dart';
import 'package:htlib/src/view/borrowing_history_management/borrowing_history_management_screen.dart';
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
          icon: Feather.user,
        ),
      ],
      floatingActionButton: Builder(
        builder: (context) => OpenContainer(
          openColor: Colors.transparent,
          closedColor: Colors.transparent,
          closedElevation: 8.0,
          closedShape: const CircleBorder(),
          openBuilder: (context, action) => [
            AddingBookDialog(),
            AddingBookDialog(),
            AddingBookDialog(),
          ][index],
          closedBuilder: (context, action) => FloatingActionButton(
            key: ValueKey(index),
            elevation: 0.0,
            hoverElevation: 0.0,
            child: PageTransitionSwitcher(
              duration: Durations.fast,
              transitionBuilder: (
                Widget child,
                Animation<double> primaryAnimation,
                Animation<double> secondaryAnimation,
              ) =>
                  ScaleTransition(
                child: child,
                scale: primaryAnimation,
              ),
              child: Icon(
                [
                  Foundation.page_copy,
                  Icons.add,
                  Icons.person_add_alt_1
                ][index],
                color: Colors.white,
                key: ValueKey(index),
              ),
            ),
            onPressed: [
              action,
              () {
                if (GetPlatform.isAndroid) {
                  action();
                } else {
                  showModal(
                      context: context, builder: (_) => AddingBookDialog());
                }
              },
              action,
            ][index],
          ),
        ),
      ),
      onNavigationIndexChange: (value) => setState(() => index = value),
      body: PageTransitionSwitcher(
        duration: Durations.fast,
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
          transitionType: SharedAxisTransitionType.vertical,
        ),
        child: [
          BorrowingHistoryManagementScreen(),
          BookManagementScreen(),
          UserManagementScreen(),
          Container(),
        ][index],
      ),
    );
  }
}
