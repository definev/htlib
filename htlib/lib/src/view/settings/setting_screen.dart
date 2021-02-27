import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/styles.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  HtlibDb db = Get.find();
  int _themeValue = 0;

  Widget _appBar(BuildContext context) {
    return Container(
      height: 59.0,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          HSpace(8.0),
          IconButton(
            icon: Icon(
              Feather.settings,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {},
          ),
          HSpace(20.0),
          Text(
            AppConfig.tabSetting,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ],
      ),
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
      child: Column(
        children: [
          _appBar(context),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.m, vertical: Insets.sm),
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
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.m, vertical: Insets.sm),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
