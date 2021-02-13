import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:htlib/_internal/utils/error_utils.dart';
import 'package:htlib/src/model/book_base.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/services/book/excel_service.dart';
import 'package:injectable/injectable.dart';

GetIt getIt = GetIt.instance;

@Singleton(dependsOn: [HtlibDb])
class BookService {
  @factoryMethod
  static Future<BookService> getBookService() async {
    BookService bookService = BookService();
    await bookService.init();
    return bookService;
  }

  List<BookBase> _list = [];
  List<BookBase> get list => _list ?? [];
  ExcelService excelService = ExcelService();

  void clearList() => _list = [];

  List<BookBase> search(String query) {
    query = query.trim().toLowerCase();

    if (query == "") return [];

    List<BookBase> res = _list.where((bookBase) {
      if (bookBase.isbn == query) return true;
      if (removeDiacritics(bookBase.name.toLowerCase()).contains(query))
        return true;
      if (removeDiacritics(bookBase?.publisher?.toLowerCase()).contains(query))
        return true;
      return false;
    }).toList();

    return res ?? [];
  }

  void mergeList(List<BookBase> addList) {
    _list.addAll(addList);
    _list = _list.toSet().toList();
    getIt<HtlibDb>().book.addList(addList, override: true);
    getIt<HtlibApi>().book.addList(_list);
  }

  Future<void> init() async {
    if (GetPlatform.isWindows) {
      _list = getIt<HtlibDb>().book.getList();
    } else {
      await ErrorUtils.catchNetworkError(
        onConnected: () async {
          _list = await getIt<HtlibApi>().book.getList();
        },
        onError: () {
          _list = getIt<HtlibDb>().book.getList();
        },
      );
    }
  }
}
