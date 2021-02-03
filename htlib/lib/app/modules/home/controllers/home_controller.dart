import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:url_launcher/url_launcher.dart';

enum PageType { Home, Setting, User, Analysis }
// enum PageState { Content, ContentSideTab, SideTab }

class HomeController extends GetxController {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  static void closeDrawer() {
    if (HomeController.scaffoldKey?.currentState?.isDrawerOpen ?? false) {
      Future.microtask(() => Get.back());
    }
  }

  Rx<AppTheme> appTheme;
  Rx<PageType> currentPage = PageType.Home.obs;

  BuildContext context;
  double get drawerSize => 300;

  double get contentSize {
    // if (onAddNewBorrowingHistory.value) {
    //   if (pageState.value == PageState.ContentSideTab) {
    //     return context.width - drawerSize - tabSize;
    //   }
    //   return context.width - drawerSize;
    // } else {
    return BuildUtils.getResponsive<double>(
      context,
      desktop: context.width - drawerSize,
      tablet: context.width - drawerSize,
      tabletPortrait: context.width,
      mobile: context.width,
    );
    // }
  }

  double get tabSize => 400;

  double get contentPosition {
    return BuildUtils.getResponsive<double>(
      context,
      desktop: drawerSize,
      tablet: drawerSize,
      tabletPortrait: 0,
      mobile: 0,
    );
  }

  double get tabPosition {
    return BuildUtils.getResponsive<double>(
      context,
      desktop: drawerSize + contentSize,
      tablet: drawerSize + contentSize,
      tabletPortrait: 0,
      mobile: 0,
    );
  }

  // RxBool onAddNewBorrowingHistory = false.obs;
  // Rx<PageState> pageState;
  // void updateState() {
  //   pageState = BuildUtils.getResponsive(
  //     context,
  //     desktop: onAddNewBorrowingHistory.value
  //         ? PageState.ContentSideTab
  //         : PageState.Content,
  //     tablet: onAddNewBorrowingHistory.value
  //         ? PageState.ContentSideTab
  //         : PageState.Content,
  //     mobile: onAddNewBorrowingHistory.value
  //         ? PageState.SideTab
  //         : PageState.Content,
  //     tabletPortrait: onAddNewBorrowingHistory.value
  //         ? PageState.SideTab
  //         : PageState.Content,
  //   ).obs;
  // }

  void openMenu() => scaffoldKey.currentState.openDrawer();

  void forceCloseDrawerIfInDesktopMode() {
    if (context.width >= PageBreaks.TabletLandscape) closeDrawer();
  }

  void goToFacebook() async {
    const url = 'https://www.facebook.com/definev/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void goToZalo() {}

  @override
  void onInit() {
    super.onInit();
    appTheme = Get.find<Rx<AppTheme>>();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
