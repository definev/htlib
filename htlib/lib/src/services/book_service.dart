import 'dart:async';
import 'package:universal_io/io.dart';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/services/book/adding_book_dialog_service.dart';
import 'package:htlib/src/services/book/excel_service.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/state_management/core/cubit_list/cubit/list_cubit.dart';
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
  ListCubit<Book> bookListCubit;

  ExcelService excelService = ExcelService();
  AddingBookDialogService addingBookDialogService = AddingBookDialogService();

  void editFromBookMap(Map<String, int> bookMap) {
    List<Book> editBookList = [];
    getList().forEach((b) {
      if (bookMap[b.isbn] != null) {
        Book newBook = b;
        newBook =
            newBook.copyWith(quantity: newBook.quantity + bookMap[b.isbn]);
        editBookList.add(newBook);
        print("BOOK: ${b.name} with ${b.quantity} book edited!");
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
    bookListBloc.add(ListEvent.add(book));
    bookListCubit.add(book);
    update(book, CRUDActionType.add);
  }

  @override
  void edit(Book book) {
    bookListBloc.add(ListEvent.edit(book));
    bookListCubit.edit(book);
    update(book, CRUDActionType.edit);
  }

  void addList(List<Book> addList) {
    bookListBloc.add(ListEvent.addList(addList));
    bookListCubit.addList(addList);
    update(addList, CRUDActionType.addList);
  }

  void remove(Book book) {
    bookListBloc.add(ListEvent.remove(book));
    bookListCubit.remove(book);
    update(book, CRUDActionType.remove);
  }

  Future<void> init() async {
    bookListBloc = ListBloc<Book>();
    bookListCubit = ListCubit<Book>();

    List<Book> _list = [];

    if (kIsWeb) {
      _list = await api.book.getList();
    } else if (GetPlatform.isWindows) {
      _list = db.book.getList();
    } else if (Platform.isAndroid) {
      try {
        _list = await api.book.getList();
        db.book.addList(_list, override: true);
      } catch (_) {
        _list = db.book.getList();
      }
    }

    bookListCubit.addList(_list);
    bookListBloc.add(ListEvent.addList(_list));
  }

  @override
  Book getDataById(String id) {
    Book res = getList().firstWhere((data) => data.isbn == id);
    return res;
  }

  List<Book> getListDataByMap(Map<String, int> map) {
    List<Book> data = [];

    getList().forEach((e) {
      if (map.containsKey(e.isbn)) {
        Book book = e;
        book = book.copyWith(quantity: map[e.isbn]);
        data.add(book);
      }
    });

    return data;
  }

  @override
  List<Book> getListDataByListId(List<String> idList) {
    return [];
  }

  @override
  List<Book> getList() => bookListCubit.list ?? [];
}
