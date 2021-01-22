import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:url_launcher/url_launcher.dart';

enum PageType { Home, Setting, User, Analysis }

class HomeController extends GetxController {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  static void closeDrawer() {
    if (HomeController.scaffoldKey?.currentState?.isDrawerOpen ?? false) {
      Future.microtask(() => Get.back());
    }
  }

  Rx<AppTheme> appTheme;
  Rx<PageType> currentPage = PageType.Home.obs;

  void openMenu() => scaffoldKey.currentState.openDrawer();

  void forceCloseDrawerIfInDesktopMode(BuildContext context) {
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

  double drawerSize(BuildContext context) => 300;

  double homeSize(BuildContext context) {
    return BuildUtils.getResponsive<double>(
      context,
      desktop: Get.width - 300,
      tablet: Get.width - 300,
      tabletPortrait: Get.width,
      mobile: Get.width,
    );
  }

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
