import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/styles.dart';

class AddBookBaseDialogController extends GetxController {
  TextEditingController nameCtl = TextEditingController();
  TextEditingController publisherCtl = TextEditingController();
  TextEditingController yearCtl = TextEditingController();
  TextEditingController priceCtl = TextEditingController();
  TextEditingController typeCtl = TextEditingController();
  TextEditingController quantityCtl = TextEditingController();

  TextField nameTextField;
  TextField publisherTextField;
  TextField yearTextField;
  TextField priceTextField;
  TextField typeTextField;
  TextField quantityTextField;

  void reset() {
    nameCtl.clear();
    publisherCtl.clear();
    yearCtl.clear();
    priceCtl.clear();
    typeCtl.clear();
    quantityCtl.clear();
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
    publisherTextField = TextField(
      controller: publisherCtl,
      keyboardType: TextInputType.text,
      style: TextStyles.Body1.textColor(Colors.black),
      decoration: InputDecoration(
        hintText: "Nhập nhà xuất bản",
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
        hintText: "Nhập thể loại",
        hintStyle: TextStyles.Body1.textColor(Colors.black54),
      ),
    );
    quantityTextField = TextField(
      controller: quantityCtl,
      keyboardType: TextInputType.phone,
      style: TextStyles.Body1.textColor(Colors.black),
      decoration: InputDecoration(
        hintText: "Nhập số lượng",
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
