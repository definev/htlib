import 'dart:async';

import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:htlib/src/model/book_base.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/services/book/adding_book_dialog_service.dart';
import 'package:htlib/src/services/book/excel_service.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:injectable/injectable.dart';

GetIt getIt = GetIt.instance;

@Singleton(dependsOn: [HtlibDb], signalsReady: true)
class BookService implements CRUDService<Book> {
  @factoryMethod
  static Future<BookService> getBookService() async {
    BookService bookService = BookService();
    await bookService.init();
    return bookService;
  }

  ListBloc<Book> bookListBloc;

  ExcelService excelService = ExcelService();
  AddingBookDialogService addingBookDialogService = AddingBookDialogService();

  Future<void> update(dynamic data, CRUDActionType actionType,
      {bool isMock = false}) async {
    if (actionType == CRUDActionType.add) {
      getIt<HtlibDb>().book.add(data);
      if (!isMock) await getIt<HtlibApi>().book.add(data);
    } else if (actionType == CRUDActionType.addList) {
      getIt<HtlibDb>().book.addList(data);
      if (!isMock) await getIt<HtlibApi>().book.addList(data);
    } else if (actionType == CRUDActionType.remove) {
      getIt<HtlibDb>().book.remove(data);
      if (!isMock) await getIt<HtlibApi>().book.remove(data);
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

    if (GetPlatform.isDesktop) {
      _list = getIt<HtlibDb>().book.getList();
    } else {
      try {
        _list = await getIt<HtlibApi>().book.getList();
        getIt<HtlibDb>().book.addList(_list, override: true);
      } catch (_) {
        _list = getIt<HtlibDb>().book.getList();
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
