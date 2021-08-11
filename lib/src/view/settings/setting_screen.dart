import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/view/login_screen.dart';
import 'package:htlib/src/view/settings/components/setting_bottom_bar.dart';
import 'package:htlib/src/widget/htlib_sliver_app_bar.dart';
import 'package:htlib/styles.dart';

class SettingScreen extends StatefulWidget {
  static const route = "/home/setting";

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  HtlibDb db = Get.find();
  int? _themeValue = 0;
  int _themeMode = 0;
  AdminService? adminService;

  Widget _appBar(BuildContext context) {
    return HtlibSliverAppBar(
      bottom: SettingBottomBar(),
      title: AppConfig.tabSetting,
    );
  }

  @override
  void initState() {
    super.initState();
    _themeValue = db.config.theme;
    _themeMode = db.config.themeMode;
    try {
      adminService = Get.find<AdminService>();
    } catch (e) {}
  }

  Widget _userMode(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _appBar(context),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              ExpansionTile(
                title: Text('Cài đặt'),
                children: [
                  Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: Insets.m + 6.0, vertical: Insets.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Đổi chủ đề",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        DropdownButton(
                          onChanged: (dynamic value) {
                            setState(() {
                              _themeValue = value;
                              db.config.setTheme(_themeValue);
                            });
                          },
                          value: _themeValue,
                          items: FlexScheme.values.map((e) {
                            return DropdownMenuItem(
                              child: Text(e.toString().substring(11)),
                              value: e.index,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: Insets.m + 6.0, vertical: Insets.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Chế độ tối", style: Theme.of(context).textTheme.bodyText1),
                        Switch(
                          value: _themeMode == 0 ? false : true,
                          onChanged: (value) {
                            _themeMode = value ? 1 : 0;
                            db.config.setThemeMode(_themeMode);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: Insets.m + 6.0, vertical: Insets.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hình dạng nút",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        ToggleButtons(
                          onPressed: (value) {
                            db.config.setButtonMode(value);
                            setState(() {});
                          },
                          children: [
                            Icon(Icons.crop_square_outlined),
                            Icon(MaterialCommunityIcons.diamond_outline),
                          ],
                          isSelected: db.config.buttonMode == 0 ? [true, false] : [false, true],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: Insets.m + 6.0, vertical: Insets.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Về ứng dụng",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          width: 126.0,
                          child: OutlinedButton(
                            onPressed: () {
                              showAboutDialog(
                                context: context,
                                applicationIcon: FlutterLogo(),
                                applicationName: AppConfig.appName,
                                applicationVersion: AppConfig.version,
                                applicationLegalese: AppConfig.description,
                              );
                            },
                            child: Text("Xem thêm"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: Insets.m + 6.0, vertical: Insets.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        SizedBox(
                          height: 45,
                          width: 126.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              await Get.find<HtlibApi>().login.signOut();
                              Get.find<HtlibDb>().config.removeFirebaseUser();

                              Navigator.popAndPushNamed(context, LoginScreen.route);
                            },
                            child: Text("Đăng xuất"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _librarianMode(BuildContext context) {
    return Center(child: Text('Librarian Mode'));
  }

  Widget _mornitorMode(BuildContext context) {
    return Center(child: Text('Mornitor Mode'));
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _userMode(context);

    if (adminService != null) {
      switch (adminService!.currentUser.type) {
        case AdminType.librarian:
          child = _librarianMode(context);
          break;
        case AdminType.mornitor:
          child = _mornitorMode(context);
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
