import 'dart:async';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/services/book/adding_book_dialog_service.dart';
import 'package:htlib/src/services/book/excel_service.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';

class BookService implements CRUDService<Book> {
  static Future<BookService> getService() async {
    BookService bookService = BookService();
    await bookService.init();
    return bookService;
  }

  HtlibApi api = Get.find<HtlibApi>();
  HtlibDb db = Get.find<HtlibDb>();

  ListBloc<Book> bookListBloc;

  ExcelService excelService = ExcelService();
  AddingBookDialogService addingBookDialogService = AddingBookDialogService();

  Future<void> update(dynamic data, CRUDActionType actionType,
      {bool isMock = false}) async {
    if (actionType == CRUDActionType.add) {
      db.book.add(data);
      await api.book.add(data);
    } else if (actionType == CRUDActionType.addList) {
      db.book.addList(data);
      await api.book.addList(data);
    } else if (actionType == CRUDActionType.remove) {
      db.book.remove(data);
      await api.book.remove(data);
    }
  }

  List<Book> search(String query, {List<Book> src, bool checkEmpty = false}) {
    query = query.trim().toLowerCase();

    if (query == "") return [];

    List<Book> res = (src ?? getList()).where((book) {
      if (book.quantity == 0 && checkEmpty == true) return false;
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

    if (kIsWeb) {
      _list = await api.book.getList();
    } else if (GetPlatform.isWindows) {
      _list = db.book.getList();
    } else {
      try {
        _list = await api.book.getList();
        db.book.addList(_list, override: true);
      } catch (_) {
        _list = db.book.getList();
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
