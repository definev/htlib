import 'package:animations/animations.dart';
import "package:flutter/material.dart";
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import 'package:htlib/_internal/components/adaptive_scaffold.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/view/book_management/book_management_screen.dart';
import 'package:htlib/src/view/book_management/components/dialog/adding_book_dialog.dart';
import 'package:htlib/src/view/renting_history_management/components/dialog/adding_renting_history_dialog.dart';
import 'package:htlib/src/view/single_user/single_user_screen.dart';
import 'package:htlib/src/view/user_management/components/dialog/adding_user_dialog.dart';
import 'package:htlib/src/view/renting_history_management/renting_history_management_screen.dart';
import 'package:htlib/src/view/settings/setting_screen.dart';
import 'package:htlib/src/view/user_management/user_management_screen.dart';
import 'package:htlib/styles.dart';

part 'home_binding.dart';

class HomeScreen extends StatefulWidget {
  static String route = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  AdminService? adminService;

  @override
  void initState() {
    super.initState();
    try {
      adminService = Get.find<AdminService>();
    } catch (e) {
      adminService = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (adminService == null) {
      return AdaptiveScaffold(
        currentIndex: index,
        destinations: [
          AdaptiveScaffoldDestination(
            title: AppConfig.tabBook,
            icon: Feather.book_open,
          ),
          AdaptiveScaffoldDestination(
            title: AppConfig.tabProfile,
            icon: Feather.user,
          ),
          AdaptiveScaffoldDestination(
            title: AppConfig.tabSetting,
            icon: Feather.settings,
          ),
        ],
        floatingActionButton: index == 1 || index == 2
            ? null
            : Builder(
                builder: (context) => OpenContainer(
                  openColor: Colors.transparent,
                  closedColor: Colors.transparent,
                  closedElevation: 8.0,
                  openBuilder: (context, action) => [
                    AddingBookDialog(),
                    null,
                    null,
                  ][index]!,
                  closedShape: Theme.of(context).floatingActionButtonTheme.shape!,
                  closedBuilder: (context, action) => FloatingActionButton(
                    key: ValueKey(index),
                    child: Icon(
                      <IconData?>[Feather.folder_plus, Feather.plus, Feather.user_plus, null][index],
                      color: Theme.of(context).colorScheme.onPrimary,
                      key: ValueKey(index),
                    ),
                    onPressed: [
                      () {
                        if (GetPlatform.isAndroid || GetPlatform.isIOS) {
                          action();
                        } else {
                          showModal(context: context, builder: (_) => AddingBookDialog());
                        }
                      },
                      action,
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
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark]))),
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
                BookManagementScreen(),
                SingleUserScreen(),
                SettingScreen(),
              ][index],
            ),
          ],
        ),
      );
    }

    switch (adminService!.currentUser.value.adminType) {
      case AdminType.librarian:
        return AdaptiveScaffold(
          currentIndex: index,
          destinations: [
            AdaptiveScaffoldDestination(
              title: AppConfig.tabRentingHistory,
              icon: Feather.file_text,
            ),
            AdaptiveScaffoldDestination(
              title: AppConfig.tabBook,
              icon: Feather.book_open,
            ),
            AdaptiveScaffoldDestination(
              title: AppConfig.tabUser,
              icon: Feather.users,
            ),
            AdaptiveScaffoldDestination(
              title: AppConfig.tabSetting,
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
                    ][index]!,
                    closedShape: Theme.of(context).floatingActionButtonTheme.shape!,
                    closedBuilder: (context, action) => FloatingActionButton(
                      key: ValueKey(index),
                      child: Icon(
                        <IconData?>[Feather.folder_plus, Feather.plus, Feather.user_plus, null][index],
                        color: Theme.of(context).colorScheme.onPrimary,
                        key: ValueKey(index),
                      ),
                      onPressed: [
                        () {
                          if (GetPlatform.isAndroid || GetPlatform.isIOS) {
                            action();
                          } else {
                            showModal(context: context, builder: (_) => AddingRentingHistoryDialog());
                          }
                        },
                        () {
                          if (GetPlatform.isAndroid || GetPlatform.isIOS) {
                            action();
                          } else {
                            showModal(context: context, builder: (_) => AddingBookDialog());
                          }
                        },
                        () {
                          if (GetPlatform.isAndroid || GetPlatform.isIOS) {
                            action();
                          } else {
                            showModal(context: context, builder: (_) => AddingUserDialog());
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
                  color: Theme.of(context).primaryColor,
                ),
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
      case AdminType.mornitor:
        return AdaptiveScaffold(
          currentIndex: index,
          destinations: [
            AdaptiveScaffoldDestination(
              title: AppConfig.tabBook,
              icon: Feather.book_open,
            ),
            AdaptiveScaffoldDestination(
              title: AppConfig.tabUser,
              icon: Feather.users,
            ),
            AdaptiveScaffoldDestination(
              title: AppConfig.tabSetting,
              icon: Feather.settings,
            ),
          ],
          floatingActionButton: index == 2
              ? null
              : Builder(
                  builder: (context) => OpenContainer(
                    openColor: Colors.transparent,
                    closedColor: Colors.transparent,
                    closedElevation: 8.0,
                    openBuilder: (context, action) => [
                      AddingBookDialog(),
                      AddingUserDialog(),
                      null,
                    ][index]!,
                    closedShape: Theme.of(context).floatingActionButtonTheme.shape!,
                    closedBuilder: (context, action) => FloatingActionButton(
                      key: ValueKey(index),
                      child: Icon(
                        <IconData?>[Feather.folder_plus, Feather.plus, Feather.user_plus, null][index],
                        color: Theme.of(context).colorScheme.onPrimary,
                        key: ValueKey(index),
                      ),
                      onPressed: [
                        () {
                          if (GetPlatform.isAndroid || GetPlatform.isIOS) {
                            action();
                          } else {
                            showModal(context: context, builder: (_) => AddingBookDialog());
                          }
                        },
                        () {
                          if (GetPlatform.isAndroid || GetPlatform.isIOS) {
                            action();
                          } else {
                            showModal(context: context, builder: (_) => AddingUserDialog());
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
                  color: Theme.of(context).primaryColor,
                ),
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
                  BookManagementScreen(),
                  UserManagementScreen(),
                  SettingScreen(),
                ][index],
              ),
            ],
          ),
        );
      case AdminType.tester:
        return SizedBox();
    }
  }
}
