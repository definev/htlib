import 'dart:async';

import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/services/book/adding_book_dialog_service.dart';
import 'package:htlib/src/services/book/excel_service.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton(dependsOn: [HtlibDb], signalsReady: true)
class BookService implements CRUDService<Book> {
  @factoryMethod
  static Future<BookService> getService() async {
    BookService bookService = BookService();
    await bookService.init();
    return bookService;
  }

  ListBloc<Book> bookListBloc;

  ExcelService excelService = ExcelService();
  AddingBookDialogService addingBookDialogService = AddingBookDialogService();

  Future<void> update(dynamic data, CRUDActionType actionType,
      {bool isMock = true}) async {
    if (actionType == CRUDActionType.add) {
      Get.find<HtlibDb>().book.add(data);
      if (!isMock) await Get.find<HtlibApi>().book.add(data);
    } else if (actionType == CRUDActionType.addList) {
      Get.find<HtlibDb>().book.addList(data);
      if (!isMock) await Get.find<HtlibApi>().book.addList(data);
    } else if (actionType == CRUDActionType.remove) {
      Get.find<HtlibDb>().book.remove(data);
      if (!isMock) await Get.find<HtlibApi>().book.remove(data);
    }
  }

  List<Book> search(String query) {
    query = query.trim().toLowerCase();

    if (query == "") return [];

    List<Book> res = getList().where((book) {
      if (book.isbn == query) return true;
      if (removeDiacritics(book.name.toLowerCase()).contains(query))
        return true;
      if (removeDiacritics(book?.publisher?.toLowerCase()).contains(query))
        return true;
      return false;
    }).toList();

    return res ?? [];
  }

  void add(Book book) {
    bookListBloc.add(ListEvent<Book>.add(book));
    update(book, CRUDActionType.add);
  }

  void addList(List<Book> addList) {
    bookListBloc.add(ListEvent<Book>.addList(addList));
    update(addList, CRUDActionType.addList);
  }

  void remove(Book book) {
    bookListBloc.add(ListEvent<Book>.remove(book));
    update(book, CRUDActionType.remove);
  }

  Future<void> init() async {
    bookListBloc = ListBloc<Book>();

    List<Book> _list = [];

    if (GetPlatform.isWindows) {
      _list = Get.find<HtlibDb>().book.getList();
    } else {
      try {
        _list = await Get.find<HtlibApi>().book.getList();
        Get.find<HtlibDb>().book.addList(_list, override: true);
      } catch (_) {
        _list = Get.find<HtlibDb>().book.getList();
      }
    }

    bookListBloc.add(ListEvent<Book>.addList(_list));
  }

  @override
  Book getDataById(String id) {
    Book res = getList().firstWhere((data) => data.isbn == id);
    return res;
  }

  @override
  List<Book> getList() => bookListBloc.list ?? [];
}
