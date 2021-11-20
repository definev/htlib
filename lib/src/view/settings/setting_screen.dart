import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/services/single_user_service.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/view/librarian_panel/librarian_panel.dart';
import 'package:htlib/src/view/mornitor_panel/mornitor_panel.dart';
import 'package:htlib/src/view/settings/components/setting_bottom_bar.dart';
import 'package:htlib/src/view/settings/components/setting_section.dart';
import 'package:htlib/src/widget/htlib_sliver_app_bar.dart';
import 'package:htlib/styles.dart';

class SettingScreen extends StatefulWidget {
  static const route = "/home/setting";

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  HtlibDb db = Get.find();
  AdminService? adminService;
  SingleUserService? singleUserService;

  Widget _appBar(BuildContext context) {
    return HtlibSliverAppBar(
      bottom: SettingBottomBar(),
      title: AppConfig.tabSetting,
    );
  }

  @override
  void initState() {
    super.initState();
    try {
      adminService = Get.find<AdminService>();
      singleUserService = Get.find<SingleUserService>();
    } catch (e) {}
  }

  Widget _userMode(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _appBar(context),
        SliverList(
          delegate: SliverChildListDelegate(
            [SettingSection()],
          ),
        ),
      ],
    );
  }

  Widget _librarianMode(BuildContext context) {
    return LibrarianPanel();
  }

  Widget _mornitorMode(BuildContext context) {
    return MornitorPanel();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _userMode(context);

    if (adminService != null) {
      if (!isContinue()) {
        child = _librarianMode(context);
      } else {
        switch (adminService!.currentUser.value.adminType) {
          case AdminType.librarian:
            child = _librarianMode(context);
            break;
          case AdminType.mornitor:
            child = _mornitorMode(context);
            break;
          case AdminType.tester:
            child = SizedBox();
            break;
        }
      }
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Durations.fastest,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: child,
      ),
      child: child,
    );
  }
}
