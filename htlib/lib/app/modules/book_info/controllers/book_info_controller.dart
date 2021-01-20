import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/modules/book_management/controllers/book_management_controller.dart';

class BookInfoController extends GetxController {
  Rx<BookBase> rxBookBase;
  BuildContext context;

  double get drawerSize => BuildUtils.getResponsive<double>(
        context,
        desktop: 300,
        tablet: 300,
        mobile: 300,
      );

  double get homeSize => BuildUtils.getResponsive<double>(
        context ?? Get.context,
        desktop: Get.width - 300,
        tablet: Get.width - 300,
        mobile: Get.width,
      );

  double get positionedHome => BuildUtils.getResponsive<double>(
        context,
        desktop: 300,
        tablet: 300,
        mobile: 0,
      );

  void setBookBase(BookBase bookBase) => rxBookBase == null
      ? rxBookBase = bookBase.obs
      : rxBookBase.value = bookBase;

  void backToDashboard() {
    BookManagementController bookManagementController = Get.find();
    bookManagementController.currentScreen.value = 0;
  }
}
