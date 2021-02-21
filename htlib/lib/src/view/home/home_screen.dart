import 'package:animations/animations.dart';
import "package:flutter/material.dart";
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:htlib/_internal/components/adaptive_scaffold.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/resources/resources.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/view/book_management/book_management_screen.dart';
import 'package:htlib/src/view/book_management/dialog/adding_book_dialog.dart';
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
  final GetIt getIt = GetIt.instance;
  int oldIndex = 0;
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
      logo: !PageBreak.defaultPB.isMobile(context)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      padding: EdgeInsets.all(Insets.sm),
                      child: Image.asset(Images.htLogo),
                    ),
                    if (PageBreak.defaultPB.isDesktop(context)) ...[
                      HSpace(Insets.l),
                      Text(
                        AppConfig.title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ],
                ),
                Divider(),
              ],
            )
          : null,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: PageTransitionSwitcher(
            duration: Durations.fast,
            reverse: oldIndex > index,
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
              [Foundation.page_copy, Icons.add, Icons.person_add_alt_1][index],
              color: Colors.white,
              key: ValueKey(index),
            ),
          ),
          onPressed: () {
            showModal(
              context: context,
              builder: (_) => AddingBookDialog(),
            );
          },
        ),
      ),
      onNavigationIndexChange: (value) => setState(() {
        oldIndex = index;
        index = value;
      }),
      body: PageTransitionSwitcher(
        duration: Durations.fast,
        reverse: oldIndex > index,
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) =>
            FadeScaleTransition(
          child: child,
          animation: primaryAnimation,
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
