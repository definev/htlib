import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/app/modules/dialogs/add_borrowing_history_dialog/bindings/add_borrowing_history_dialog_binding.dart';
import 'package:htlib/app/modules/home/controllers/home_controller.dart';
import 'package:htlib/app/modules/home/views/button_tile_view.dart';
import 'package:htlib/app/modules/dialogs/add_borrowing_history_dialog/views/add_borrowing_history_dialog_view.dart';
import 'package:htlib/resources/resources.dart';
import 'package:htlib/styled_components/buttons/base_styled_button.dart';
import 'package:htlib/styled_components/styled_container.dart';
import 'package:htlib/_internal/components/animated_panel.dart';
import 'package:htlib/styled_components/styled_custom_icon.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';

import 'package:styled_widget/styled_widget.dart';

class MenuDrawerView extends GetView<HomeController> {
  final bool isScaffoldDrawer;

  MenuDrawerView(this.isScaffoldDrawer);

  @override
  Widget build(BuildContext context) {
    HomeController hCtrl = Get.find();
    return Obx(() {
      AppTheme appTheme = controller.appTheme.value;
      return StyledContainer(
        appTheme.bg1,
        height: context.height,
        width: hCtrl.drawerSize,
        child: Column(
          children: [
            Container(child: Image.asset(Images.htLogo).center()),
            StyledContainer(
              appTheme.accent1,
              borderRadius:
                  BorderRadius.only(topRight: Radius.circular(Insets.m)),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: ButtonTileView.leadingTitle.length,
                      itemBuilder: (context, index) => Obx(
                        () => ButtonTileView(
                          index: index,
                          isSelected:
                              controller.currentPage == PageType.values[index]
                                  ? true
                                  : false,
                          leadingIcon: ButtonTileView.leadingTitle[index].item1,
                          title: ButtonTileView.leadingTitle[index].item2,
                          onTap: (index) {
                            if (index == 0) {
                              // controller.onAddNewBorrowingHistory.value =
                              //     !controller.onAddNewBorrowingHistory.value;
                              Future(() {
                                AddBorrowingHistoryDialogBinding()
                                    .dependencies();
                                Get.dialog(AddBorrowingHistoryDialogView());
                              });
                            } else {
                              controller.currentPage.value =
                                  PageType.values[index - 1];
                            }
                          },
                        ).paddingSymmetric(horizontal: Insets.m),
                      ),
                    ),
                  ),
                  Divider(color: appTheme.bg1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextStyles.Body1Text(
                        "Phiên bản 1.0.0",
                        color: Colors.white,
                      ),
                      Row(
                        children: [
                          BaseStyledBtn(
                            child: StyledCustomIcon(
                              MaterialCommunityIcons.phone_classic,
                              color: appTheme.accent3,
                            ),
                            onPressed: controller.goToFacebook,
                          ),
                          HSpace(Insets.sm),
                          BaseStyledBtn(
                            child: StyledCustomIcon(
                              MaterialCommunityIcons.facebook,
                              color: appTheme.accent3,
                            ),
                            onPressed: controller.goToFacebook,
                          ),
                        ],
                      ),
                    ],
                  ).paddingSymmetric(horizontal: Insets.m, vertical: Insets.m),
                ],
              ).paddingOnly(top: Insets.m),
            ).expanded(),
          ],
        ),
      ).animatedPanelX(
        closeX: -(hCtrl.drawerSize),
        isClosed: BuildUtils.getResponsive<bool>(
          context,
          desktop: isScaffoldDrawer ? true : false,
          tablet: isScaffoldDrawer ? true : false,
          tabletPortrait: isScaffoldDrawer ? false : true,
          mobile: isScaffoldDrawer ? false : true,
        ),
      );
    });
  }
}
