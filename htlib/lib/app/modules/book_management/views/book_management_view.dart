import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/app/modules/book_info/views/book_info_view.dart';

import 'package:htlib/app/modules/book_management/controllers/book_management_controller.dart';
import 'package:htlib/app/modules/dashboard/views/dashboard_view.dart';
import 'package:htlib/app/modules/home/controllers/home_controller.dart';
import 'package:styled_widget/styled_widget.dart';

class BookManagementView extends GetView<BookManagementController> {
  @override
  Widget build(BuildContext context) {
    HomeController hCtrl = Get.find();
    return Row(
      children: [
        DashboardView().constrained(width: hCtrl.listViewSize(context)),
        if (!BuildUtils.isTabletPortrait(context)) BookInfoView(),
      ],
    );
  }
}
