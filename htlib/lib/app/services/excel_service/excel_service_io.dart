import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/services/excel_service/excel_service.dart';

ExcelServiceIo getExcelService(dynamic file) => ExcelServiceIo(file);

class ExcelServiceIo implements ExcelService {
  @override
  Excel excel;
  ExcelServiceIo(File file) {
    assert(file != null);
    if (file.existsSync() == false) throw Exception("File is not exist");
    excel = Excel.decodeBytes(file.readAsBytesSync());
  }

  List<BookBase> getBookBaseList() {
    List<BookBase> res = [];
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
        if (nullAmount <= 9) res.add(BookBase.fromExcelRow(row));
      });
    });

    Queue<BookBase> copyRes = Queue.from([...res]);
    res = [];
    BookBase bb = copyRes.first;
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
