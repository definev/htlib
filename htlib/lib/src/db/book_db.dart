import 'package:htlib/src/db/core/crud_db.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/db/core_db.dart';

import '../model/book.dart';

class BookDb extends CoreDb<Book> implements CRUDDb<Book> {
  BookDb() : super("BookDb", adapter: [BookAdapter()]);

  void add(Book book) => this.write(book.isbn, book);

  void addList(List<Book> bookList, {bool override = false}) {
    bookList.forEach((book) {
      if (override == false) {
        bool inDb = this.box.values.contains(book);
        if (!inDb) add(book);
      } else {
        add(book);
      }
    });
  }

  void remove(Book book) => this.delete(book.isbn);

  void removeList(List<Book> bookList) => bookList.forEach((b) => remove(b));

  List<Book> getList() {
    List<Book> res = this
        .box
        .values
        .where((e) {
          if (e is Book) return true;
          return false;
        })
        .toList()
        .cast();

    return res;
  }

  Book getDataById(String id) => this.read(id);
}
