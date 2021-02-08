import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/app/modules/home/controllers/home_controller.dart';
import 'package:htlib/styled_components/buttons/menu_button.dart';
import 'package:htlib/styled_components/buttons/primary_btn.dart';
import 'package:htlib/styles.dart';

import 'package:styled_widget/styled_widget.dart';
import 'package:htlib/app/modules/dashboard/controllers/dashboard_controller.dart';

import 'package:htlib/styled_components/styled_container.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    HomeController hCtrl = Get.find();
    return Scaffold(
      body: StyledContainer(
        Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MenuButton(),
                PrimaryBtn(
                  bigMode: true,
                  child: TextStyles.H2Text("Bảng quản lí sách"),
                  onPressed: () {},
                ).clipRRect(bottomLeft: 40, topLeft: 40),
              ],
            ).paddingOnly(bottom: Insets.m),
            controller.functionBar(),
            VSpace(Insets.m),
          ],
        ).paddingAll(Insets.mid),
      ),
    ).constrained(width: hCtrl.contentSize(context));
  }
}
