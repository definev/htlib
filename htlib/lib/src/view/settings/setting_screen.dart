import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/view/settings/components/setting_bottom_bar.dart';
import 'package:htlib/src/widget/htlib_sliver_app_bar.dart';
import 'package:htlib/styles.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  HtlibDb db = Get.find();
  int _themeValue = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Durations.fastest,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: child,
      ),
      child: CustomScrollView(
        slivers: [
          _appBar(context),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.m + 6.0, vertical: Insets.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Đổi chủ đề",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      DropdownButton(
                        onChanged: (value) {
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
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.m + 6.0, vertical: Insets.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chế độ tối",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Switch(
                        value: db.config.themeMode == 0 ? false : true,
                        onChanged: (value) {
                          db.config.setThemeMode(value ? 1 : 0);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.m + 6.0, vertical: Insets.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Về ứng dụng",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Localizations.override(
                        context: context,
                        locale: Locale("vi", "VN"),
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
                            child: Text("Xem thêm")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
