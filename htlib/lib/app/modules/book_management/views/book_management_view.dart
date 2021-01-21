import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/components/fading_index_stack.dart';
import 'package:htlib/app/modules/book_info/views/book_info_view.dart';

import 'package:htlib/app/modules/book_management/controllers/book_management_controller.dart';
import 'package:htlib/app/modules/dashboard/views/dashboard_view.dart';
import 'package:htlib/styles.dart';

class BookManagementView extends GetView<BookManagementController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => FadingIndexedStack(
          duration: Durations.fastest,
          index: controller.currentScreen.value,
          children: [
            DashboardView(),
            BookInfoView(),
          ],
        ));
  }
}
