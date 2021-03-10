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

  Map<String, int> bookListToBookMap(List<String> bookList) {
    Map<String, int> _bookMap = {};
    bookList.forEach((e) {
      if (_bookMap[e] == null)
        _bookMap[e] = 1;
      else
        _bookMap[e]++;
    });
    return _bookMap;
  }

  void editFromBookList(List<String> bookList) {
    Map<String, int> _bookMap = {};
    bookList.forEach((e) {
      if (_bookMap[e] == null)
        _bookMap[e] = 1;
      else
        _bookMap[e]++;
    });
    List<Book> editBookList = [];
    getList().forEach((b) {
      if (_bookMap[b.isbn] != null) {
        Book newBook = b;
        newBook =
            newBook.copyWith(quantity: newBook.quantity + _bookMap[b.isbn]);
        editBookList.add(newBook);
        print("BOOK: ${b.name} is edited!");
      }
    });
    editBookList.forEach((book) => edit(book));
  }

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
    } else if (actionType == CRUDActionType.edit) {
      db.book.edit(data);
      await api.book.edit(data);
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

  @override
  void edit(Book book) {
    bookListBloc.add(ListEvent<Book>.edit(book));
    update(book, CRUDActionType.edit);
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
  List<Book> getListDataByListId(List<String> idList) {
    List<Book> data = [];

    getList().forEach((e) {
      if (idList.contains(e.isbn)) data.add(e);
    });

    var map = bookListToBookMap(idList);
    idList.toSet().forEach((id) {
      int index = data.indexWhere((e) => e.isbn == id);
      data[index] = data[index].copyWith(quantity: map[id]);
    });

    return data;
  }

  @override
  List<Book> getList() => bookListBloc.list ?? [];
}
