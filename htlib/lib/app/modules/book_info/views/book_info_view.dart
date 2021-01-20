import 'package:flutter/material.dart';
import 'package:htlib/styled_components/buttons/primary_btn.dart';

import 'package:styled_widget/styled_widget.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/build_utils.dart';

import 'package:htlib/app/modules/book_info/controllers/book_info_controller.dart';
import 'package:htlib/styled_components/styled_container.dart';
import 'package:htlib/styles.dart';

class BookInfoView extends GetView<BookInfoController> {
  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      body: StyledContainer(
        Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                VSpace(Insets.m),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryTextBtn(
                      "Quay lại",
                      onPressed: controller.backToDashboard,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ).paddingAll(Insets.l),
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
    ;
  }
}
