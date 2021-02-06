import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/build_utils.dart';

import 'package:htlib/app/modules/dialogs/add_borrowing_history_dialog/controllers/add_borrowing_history_dialog_controller.dart';
import 'package:htlib/app/modules/dialogs/add_borrowing_history_dialog/views/widgets/text_field/isbn/isbn_text_field.dart';
import 'package:htlib/app/modules/dialogs/add_borrowing_history_dialog/views/widgets/text_field/user/user_text_field.dart';
import 'package:htlib/styled_components/buttons/primary_btn.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:styled_widget/styled_widget.dart';

class AddBorrowingHistoryDialogView
    extends GetView<AddBorrowingHistoryDialogController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.find<Rx<AppTheme>>().value.bg1,
        border: Border.all(color: Color(0xFFB1B4BC), width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: BuildUtils.specifyForMobile(context,
            mobile: 0, defaultValue: Insets.mid),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "",
                  style: TextStyles.T1.textColor(Colors.black),
                  overflow: TextOverflow.ellipsis,
                ).expanded(),
                PrimaryTextBtn("Tìm trên google"),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Obx(() => UserTextField(
                        user: controller.user.value,
                      )),
                  VSpace(Insets.m),
                  Obx(() => ISBNTextField(
                        isbnList:
                            controller.borrowingHistory.value.isbnList ?? [],
                        onChangeIsbnList: (newIsbnList) =>
                            controller.borrowingHistory.value = controller
                                .borrowingHistory.value
                                .copyWith(isbnList: newIsbnList),
                      )),
                ],
              ).paddingSymmetric(vertical: Insets.mid),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PrimaryTextBtn(
                  "Hủy",
                  onPressed: Get.back,
                ),
                HSpace(Insets.m),
                PrimaryTextBtn(
                  "Thêm sách",
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ).paddingAll(Insets.m).constrained(
              minHeight: 650,
              maxHeight: context.height,
              minWidth: PageBreaks.LargePhone,
              height: BuildUtils.specifyForMobile(context,
                  mobile: context.height, defaultValue: 800),
              width: 1000,
            ),
      ),
    ).center();
  }
}
