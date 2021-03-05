import 'dart:collection';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/services/book_service.dart';

List<Book> getData(Excel excel) {
  List<Book> res = [];
  excel.sheets.forEach((key, value) {
    List<dynamic> rows = value.rows..removeAt(0)..removeAt(0)..removeAt(0);
    rows.forEach((row) {
      int nullAmount = 0;
      row.forEach((cell) {
        if (cell == null) nullAmount++;
      });
      if (nullAmount <= 9) res.add(Book.fromExcelRow(row));
    });
  });

  Queue<Book> copyRes = Queue.from([...res]);
  res = [];
  Book bb = copyRes.first;
  while (copyRes.isNotEmpty) {
    if (copyRes.first.name != bb.name) {
      res.add(bb);
      copyRes.removeFirst();
      if (copyRes.isNotEmpty) bb = copyRes.first;
    } else {
      bb = bb.copyWith(quantity: bb.quantity + 1);
      copyRes.removeFirst();
    }
  }

  return res;
}

class ExcelService {
  Excel excel;

  Future<List<List<Book>>> getBookList(BuildContext context) async {
    List<dynamic> files = await FileUtils.excel();

    if (files.isEmpty) return null;

    List<List<Book>> _resList = [];
    var bookService = Get.find<BookService>();

    await files.forEach((file) async {
      if (GetPlatform.isWeb) {
        excel = Excel.decodeBytes(file);
      } else {
        excel = Excel.decodeBytes(file.readAsBytesSync());
      }

      await compute(getData, excel).then((addList) {
        if (addList != null) {
          bookService.addList(addList);
        } else {
          // ignore: deprecated_member_use
          Scaffold.of(context).hideCurrentSnackBar();
          // ignore: deprecated_member_use
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("Chưa nhập mã ISBN")));
        }
      });
    });

    return _resList;
  }
}
