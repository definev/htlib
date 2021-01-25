import 'package:excel/excel.dart';
import 'package:htlib/app/data/book_base.dart';
import 'excel_service_locator.dart'
    if (dart.library.io) 'excel_service_io.dart'
    if (dart.library.html) 'excel_service_web.dart';

abstract class ExcelService {
  final Excel excel;

  List<BookBase> getBookBaseList();

  factory ExcelService(dynamic file) => getExcelService(file);
}
