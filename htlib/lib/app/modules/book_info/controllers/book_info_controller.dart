import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/modules/book_management/controllers/book_management_controller.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';

class BookInfoController extends GetxController {
  BuildContext context;

  Rx<BookBase> rxBookBase;
  Rx<AppTheme> appTheme = Get.find();
  var tabIndex = 0.obs;

  bool isInit = false;

  TabController tabController;

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

  Widget bookDesc() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${rxBookBase?.value?.name}",
            style: BuildUtils.getResponsive(
              context,
              desktop: TextStyles.ST1,
              tablet: TextStyles.ST1.copyWith(fontSize: FontSizes.s60),
              mobile: TextStyles.ST1.copyWith(fontSize: FontSizes.s48),
            ).copyWith(color: appTheme.value.accent3),
          ),
          VSpace(Insets.m),
          Text(
            "Nhà xuất bản: ${rxBookBase?.value?.publisher}",
            style: BuildUtils.getResponsive(
              context,
              desktop: TextStyles.ST2,
              tablet: TextStyles.ST2.copyWith(fontSize: FontSizes.s48),
              mobile: TextStyles.ST2.copyWith(fontSize: FontSizes.s36),
            ).copyWith(color: Colors.black54),
          ),
          Text(
            "Năm xuất bản: ${rxBookBase?.value?.year}",
            style: BuildUtils.getResponsive(
              context,
              desktop: TextStyles.ST2,
              tablet: TextStyles.ST2.copyWith(fontSize: FontSizes.s48),
              mobile: TextStyles.ST2.copyWith(fontSize: FontSizes.s36),
            ).copyWith(color: Colors.black54),
          ),
        ],
      );
  void setBookBase(BookBase bookBase) => rxBookBase == null
      ? rxBookBase = bookBase.obs
      : rxBookBase.value = bookBase;

  void backToDashboard() {
    BookManagementController bookManagementController = Get.find();
    bookManagementController.currentScreen.value = 0;
  }

  @override
  void onReady() {
    super.onReady();
  }
}
