import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib_qrcode/app/repos/core_repo.dart';

class BookRepo extends CoreRepo {
  BookRepo() : super(["appData", "book"]);

  Future<void> fireNewISBN(String isbn) async {
    var dataBucket = getData(["waitingList"]);

    await dataBucket.fold(
      (l) async {
        var i = int.tryParse(isbn);
        if (i == null) {
          ScaffoldMessenger.of(Get.context).showSnackBar(
            SnackBar(
              content: Text("Quét mã số ISBN"),
            ),
          );
          return;
        }
        ScaffoldMessenger.of(Get.context).showSnackBar(
          SnackBar(
            content: Text("Đã thêm mã $isbn"),
          ),
        );
        await l.doc("$isbn").set({});
      },
      (r) {},
    );
  }
}
