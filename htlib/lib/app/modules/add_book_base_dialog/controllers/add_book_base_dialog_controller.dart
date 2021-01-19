import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/styles.dart';

class AddBookBaseDialogController extends GetxController {
  TextEditingController nameCtl = TextEditingController();
  TextEditingController locationCtl = TextEditingController();
  TextEditingController yearCtl = TextEditingController();
  TextEditingController priceCtl = TextEditingController();
  TextEditingController typeCtl = TextEditingController();

  TextField nameTextField;
  TextField locationTextField;
  TextField yearTextField;
  TextField priceTextField;
  TextField typeTextField;

  void reset() {
    nameCtl.clear();
    locationCtl.clear();
    yearCtl.clear();
    priceCtl.clear();
    typeCtl.clear();
  }

  @override
  void onInit() {
    nameTextField = TextField(
      controller: nameCtl,
      keyboardType: TextInputType.text,
      style: TextStyles.Body1.textColor(Colors.black),
      decoration: InputDecoration(
        hintText: "Nhập tên sách",
        hintStyle: TextStyles.Body1.textColor(Colors.black54),
      ),
    );
    locationTextField = TextField(
      controller: locationCtl,
      keyboardType: TextInputType.text,
      style: TextStyles.Body1.textColor(Colors.black),
      decoration: InputDecoration(
        hintText: "Nhập nơi phát hành",
        hintStyle: TextStyles.Body1.textColor(Colors.black54),
      ),
    );
    yearTextField = TextField(
      controller: yearCtl,
      keyboardType: TextInputType.phone,
      style: TextStyles.Body1.textColor(Colors.black),
      decoration: InputDecoration(
        hintText: "Nhập năm xuất bản",
        hintStyle: TextStyles.Body1.textColor(Colors.black54),
      ),
    );
    priceTextField = TextField(
      controller: priceCtl,
      keyboardType: TextInputType.phone,
      style: TextStyles.Body1.textColor(Colors.black),
      decoration: InputDecoration(
        hintText: "Nhập giá tiền",
        hintStyle: TextStyles.Body1.textColor(Colors.black54),
      ),
    );
    typeTextField = TextField(
      controller: typeCtl,
      keyboardType: TextInputType.text,
      style: TextStyles.Body1.textColor(Colors.black),
      decoration: InputDecoration(
        hintText: "Nhập tên sách",
        hintStyle: TextStyles.Body1.textColor(Colors.black54),
      ),
    );
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
