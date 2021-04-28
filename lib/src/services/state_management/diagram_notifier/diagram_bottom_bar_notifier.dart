import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/services/book_service.dart';

class DiagramBottomBarNotifier extends ChangeNotifier {
  List<String> _unsortedBookList = [];
  List<String> get unsortedBookList => _unsortedBookList;

  setUnsortedBookList(List<String> value) {
    _unsortedBookList = value;
    List<Book> res = [];
    BookService service = Get.find();
    var _list = service.getList();
    value.forEach((id) {
      Book? book = _list.firstWhere((e) => e.id == id);
      res.add(book);
    });
    bookList = res;
    notifyListeners();
  }

  List<Book> bookList = [];

  bool expand = false;
  void setExpand(bool value) {
    expand = value;
    notifyListeners();
  }
}
