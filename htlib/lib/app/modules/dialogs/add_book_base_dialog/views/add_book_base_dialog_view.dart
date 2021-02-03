import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/app/data/book_base.dart';

import 'package:htlib/app/modules/dialogs/add_book_base_dialog/controllers/add_book_base_dialog_controller.dart';
import 'package:htlib/styled_components/buttons/primary_btn.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:styled_widget/styled_widget.dart';

class AddBookBaseDialogView extends GetView<AddBookBaseDialogController> {
  final String isbn;

  AddBookBaseDialogView(this.isbn) : assert(isbn != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.find<Rx<AppTheme>>().value.bg1,
        border: Border.all(color: Color(0xFFB1B4BC), width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.symmetric(horizontal: Insets.mid),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$isbn",
                  style: TextStyles.T1.textColor(Colors.black),
                  overflow: TextOverflow.ellipsis,
                ).expanded(),
                PrimaryTextBtn(
                  "Tìm trên google",
                  onPressed: () => controller.openSearch("$isbn"),
                ),
              ],
            ),
            Column(
              children: [
                controller.nameTextField,
                controller.publisherTextField,
                controller.yearTextField,
                controller.priceTextField,
                controller.typeTextField,
                controller.quantityTextField,
              ],
            ),
            VSpace(15),
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
                  onPressed: () {
                    Get.back(
                      result: BookBase(
                        isbn: isbn,
                        name: controller.nameCtl.text,
                        publisher: controller.publisherCtl.text,
                        year: int.parse(controller.yearCtl.text),
                        price: int.parse(controller.priceCtl.text),
                        type: controller.typeCtl.text,
                        quantity:
                            int.tryParse(controller.quantityCtl.text) ?? 1,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ).paddingAll(Insets.m).constrained(width: 500),
      ),
    ).center();
  }
}
