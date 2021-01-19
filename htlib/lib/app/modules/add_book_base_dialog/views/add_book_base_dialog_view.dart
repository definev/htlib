import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/app/data/book_base.dart';

import 'package:htlib/app/modules/add_book_base_dialog/controllers/add_book_base_dialog_controller.dart';
import 'package:htlib/styled_components/buttons/primary_btn.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:styled_widget/styled_widget.dart';

class AddBookBaseDialogView extends GetView<AddBookBaseDialogController> {
  final String isbn;

  AddBookBaseDialogView(this.isbn) : assert(isbn != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Get.find<Rx<AppTheme>>().value.bg1,
      child: Column(
        children: [
          TextStyles.T1Text("Thêm sách mới số: $isbn", color: Colors.black),
          ListView(
            children: [
              controller.nameTextField,
              controller.publisherTextField,
              controller.yearTextField,
              controller.priceTextField,
              controller.typeTextField,
              controller.quantityTextField,
            ],
          ).expanded(),
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
                      quantity: int.tryParse(controller.quantityCtl.text) ?? 1,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ).paddingAll(15).constrained(height: 600, width: 400),
    ).center();
  }
}
