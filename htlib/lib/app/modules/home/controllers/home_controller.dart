import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/app/db/htlib_db.dart';
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
  double get drawerSize => HtlibDb.config.drawerSize;
  double listViewSize(BuildContext context) {
    return BuildUtils.getResponsive<double>(
      context,
      desktop: HtlibDb.config.listViewSize,
      tablet: HtlibDb.config.listViewSize,
      tabletPortrait: HtlibDb.config.listViewSize,
      mobile: context.width,
    );
  }

  double contentSize(BuildContext context) => BuildUtils.getResponsive<double>(
        context,
        desktop: context.width - drawerSize - listViewSize(context),
        tablet: context.width - drawerSize - listViewSize(context),
        tabletPortrait: context.width - listViewSize(context),
        mobile: context.width,
      );

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
