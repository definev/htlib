import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:get/get.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/modules/dashboard/views/qr_dialog.dart';
import 'package:htlib/styled_components/buttons/base_styled_button.dart';
import 'package:htlib/styled_components/styled_custom_icon.dart';
import 'package:htlib/styled_components/styled_dialog.dart';
import 'package:htlib/themes.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CheckCellBtnView extends StatelessWidget {
  final PlutoColumnRendererContext rendererContext;

  CheckCellBtnView(this.rendererContext);
  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = Get.find<Rx<AppTheme>>().value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BaseStyledBtn(
          child: StyledCustomIcon(AntDesign.qrcode),
          contentPadding: EdgeInsets.all(3),
          bgColor: appTheme.accent3,
          hoverColor: Color.lerp(appTheme.accent3, Colors.grey, 0.98),
          downColor: appTheme.accent3,
          onPressed: () {
            Dialogs.show(
              QrDialog(bookBase: BookBase.fromPlutoRow(rendererContext.row)),
              context,
            );
          },
        ),
      ],
    );
  }
}
