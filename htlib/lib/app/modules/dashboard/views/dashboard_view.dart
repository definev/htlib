import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/_internal/utils/color_utils.dart';
import 'package:htlib/app/_external/external.dart';
import 'package:htlib/app/modules/dashboard/views/seach_bar_view.dart';
import 'package:htlib/styled_components/buttons/primary_btn.dart';
import 'package:htlib/styled_components/styled_dialog.dart';
import 'package:htlib/styles.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'package:styled_widget/styled_widget.dart';
import 'package:htlib/app/modules/dashboard/controllers/dashboard_controller.dart';

import 'package:htlib/styled_components/styled_container.dart';
import 'package:htlib/styled_components/styled_custom_icon.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      body: StyledContainer(
        Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            VSpace(Insets.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => PrimaryBtn(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StyledCustomIcon(AntDesign.delete),
                          HSpace(Insets.m),
                          TextStyles.FootnoteText(
                            "Xóa toàn bộ",
                            color: Colors.white,
                          ),
                        ],
                      ),
                      onPressed: controller.deleteBookBaseList,
                      bgColor: controller.appTheme.value.error,
                      hoverColor: Color.lerp(
                          controller.appTheme.value.error, Colors.white, 0.1),
                      downColor: controller.appTheme.value.error,
                    )),
                Container(),
                Row(
                  children: [
                    Obx(() => PrimaryBtn(
                          bgColor: controller.appTheme.value.focus,
                          hoverColor: Color.lerp(
                            controller.appTheme.value.focus,
                            Colors.white10,
                            0.9,
                          ),
                          downColor: ColorUtils.shiftHsl(
                              controller.appTheme.value.focus, -.02),
                          onPressed: controller.doAddSync,
                          child: controller.isInAddSync.value
                              ? LoadingIndicator(
                                  indicatorType: Indicator.lineScale,
                                  color: controller.appTheme.value.accent1,
                                )
                              : StyledCustomIcon(
                                  AntDesign.book,
                                  color: controller.appTheme.value.accent1,
                                  size: Sizes.iconSm,
                                ),
                        ).constrained(height: 38)),
                    HSpace(Insets.m),
                    PrimaryTextBtn(
                      "Đồng bộ trên đám mây",
                      onPressed: controller.syncData,
                    ),
                    HSpace(Insets.m),
                    PrimaryTextBtn(
                      "Thêm từ file Excel",
                      onPressed: controller.getDataFromFile,
                    ),
                  ],
                ),
              ],
            ),
            VSpace(Insets.m),
            Obx(
              () => PlutoGrid(
                mode: PlutoGridMode.popup,
                configuration:
                    PlutoGridConfiguration(localeText: PlutoUtils.vie),
                columns: controller.columns,
                rows: controller.plutoRowBookBaseList.value,
                createHeader: (stateManager) => SearchBarView(stateManager),
                onSelected: (event) {
                  log(event.row.cells.toString());
                },
                onLoaded: (event) {
                  controller.stateManager = event.stateManager;
                },
                onChanged: (event) {
                  log(event.row.cells.toString());
                  if (event.columnIdx == 0) {
                    print("Select: $event");
                    Dialogs.show(
                      StyledDialog(
                        child: TextStyles.T1Text("Value"),
                      ),
                      context,
                    );
                  }
                },
              ).expanded(),
            ),
          ],
        ).paddingAll(30),
      ),
    )
        .constrained(
          height: context.height,
          width: controller.homeSize,
        )
        .positioned(
          left: BuildUtils.getResponsive(
            context,
            desktop: controller.drawerSize,
            tablet: controller.drawerSize,
            mobile: 0,
          ),
        );
  }
}
