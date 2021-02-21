import 'dart:collection';
import 'dart:developer';

import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/src/model/book_base.dart';

class ExcelService {
  Excel excel;

  Future<List<Book>> getBookList() async {
    dynamic file = await FileUtils.excel();

    if (file == null) return null;

    if (GetPlatform.isWeb) {
      excel = Excel.decodeBytes(file);
    } else {
      excel = Excel.decodeBytes(file.readAsBytesSync());
    }

    List<Book> res = [];
    excel.sheets.forEach((key, value) {
      log(key, name: "Excel_Parsing");

      List<dynamic> rows = value.rows..removeAt(0)..removeAt(0)..removeAt(0);
      int index = -1;
      rows.forEach((row) {
        index++;
        int nullAmount = 0;
        row.forEach((cell) {
          if (cell == null) nullAmount++;
        });
        log("Row $index: $nullAmount", name: "Excel_Parsing");
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
}
