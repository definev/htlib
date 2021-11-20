import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/view/login_screen.dart';
import 'package:htlib/styles.dart';

class SettingSection extends StatefulWidget {
  const SettingSection({Key? key}) : super(key: key);

  @override
  _SettingSectionState createState() => _SettingSectionState();
}

class _SettingSectionState extends State<SettingSection> {
  HtlibDb db = Get.find();
  int? _themeValue = 0;
  int _themeMode = 0;

  @override
  void initState() {
    super.initState();
    _themeMode = db.config.themeMode;
    _themeMode = db.config.theme;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
