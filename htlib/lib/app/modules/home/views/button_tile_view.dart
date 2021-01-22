import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/components/custom_cupertino_switch.dart';
import 'package:htlib/app/modules/home/controllers/home_controller.dart';
import 'package:htlib/styled_components/buttons/primary_btn.dart';
import 'package:htlib/styled_components/styled_custom_icon.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:tuple/tuple.dart';

class ButtonTileView extends GetView {
  final int index;
  final bool isSelected;
  final IconData leadingIcon;
  final String title;
  final Function(int index) onTap;

  ButtonTileView({
    this.index,
    this.isSelected,
    this.leadingIcon,
    this.title,
    this.onTap,
  });

  static List<Tuple2<IconData, String>> leadingTitle = [
    Tuple2(Feather.book_open, "Quản lí sách"),
    Tuple2(Feather.user, "Quản lí người dùng"),
    Tuple2(Icons.settings, "Theme"),
  ];

  @override
  Widget build(BuildContext context) {
    final appTheme = Get.find<Rx<AppTheme>>();
    if (leadingTitle[index].item2 == "Theme") {
      return Container(
        width: 78,
        height: 42,
        padding: EdgeInsets.symmetric(vertical: Insets.m),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextStyles.T1Text(title, color: Colors.white),
            Obx(() => CustomCupertinoSwitch(
                  activeColor: Color(0xff006b5a),
                  value: appTheme.value.themeType == ThemeType.BlueHT
                      ? false
                      : true,
                  onChanged: (isLight) {
                    if (isLight) {
                      appTheme.value = AppTheme.fromType(ThemeType.GreenMint);
                    } else {
                      appTheme.value = AppTheme.fromType(ThemeType.BlueHT);
                    }
                    Get.changeTheme(appTheme.value.themeData);
                  },
                )),
          ],
        ),
      );
    }

    return PrimaryBtn(
      onPressed: () {
        onTap(index);
        HomeController.closeDrawer();
      },
      child: Row(
        children: [
          StyledCustomIcon(leadingIcon, size: 24).paddingAll(15),
          TextStyles.T1Text(title),
        ],
      ),
    ).paddingOnly(bottom: Insets.m);
  }
}
