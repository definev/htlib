import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:get/get.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/modules/book_info/controllers/book_info_controller.dart';
import 'package:htlib/app/modules/book_management/controllers/book_management_controller.dart';
import 'package:htlib/styled_components/styled_custom_icon.dart';
import 'package:htlib/themes.dart';
import 'package:pluto_grid/pluto_grid.dart';

class RowFunctionColumn extends StatelessWidget {
  final PlutoColumnRendererContext rendererContext;

  RowFunctionColumn(this.rendererContext);
  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = Get.find<Rx<AppTheme>>().value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: StyledCustomIcon(Feather.info, color: appTheme.accent1),
          onPressed: () {
            BookManagementController bookManagementController = Get.find();
            BookInfoController bookInfoController = Get.find();

            bookInfoController
                .setBookBase(BookBase.fromPlutoRow(rendererContext.row));
            bookManagementController.currentScreen.value = 1;
          },
        ),
      ],
    );
  }
}
