import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/app/_external/external.dart';
import 'package:htlib/app/modules/dashboard/views/seach_bar_view.dart';
import 'package:htlib/styled_components/buttons/menu_button.dart';
import 'package:htlib/styled_components/styled_dialog.dart';
import 'package:htlib/styles.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'package:styled_widget/styled_widget.dart';
import 'package:htlib/app/modules/dashboard/controllers/dashboard_controller.dart';

import 'package:htlib/styled_components/styled_container.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MenuButton(),
                TextStyles.T1Text("Bảng quản lí sách", color: Colors.black),
              ],
            ).paddingOnly(bottom: Insets.m),
            context.width <= (535 + 3 * Insets.m + 60)
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: controller.functionBar(),
                  )
                : controller.functionBar(),
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
                onLoaded: (event) =>
                    controller.stateManager = event.stateManager,
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
        ).paddingAll(Insets.mid),
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
