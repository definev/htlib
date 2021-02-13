import 'package:htlib/src/model/book_base.dart';
import 'package:htlib/src/db/core_db.dart';

import '../model/book_base.dart';

class BookDb extends CoreDb {
  BookDb() : super("BookDb", adapter: [BookBaseAdapter()]);

  List<BookBase> getList() {
    List<BookBase> res = this
        .box
        .values
        .where((e) {
          if (e is BookBase) return true;
          return false;
        })
        .toList()
        .cast();

    return res;
  }

  void add(BookBase bookBase) => this.write(bookBase.isbn, bookBase);

  void addList(List<BookBase> bookBaseList, {bool override = false}) {
    bookBaseList.forEach((bookBase) {
      if (override == false) {
        bool inDb = this.box.values.contains(bookBase);
        if (!inDb) add(bookBase);
      } else {
        add(bookBase);
      }
    });
  }

  void setBookBaseList(List<BookBase> bookBaseList) =>
      bookBaseList.forEach((bookBase) => this.write(bookBase.isbn, bookBase));

  void remove(BookBase bookBase) => this.delete(bookBase.isbn);

  void removeList(List<BookBase> bookBaseList) =>
      bookBaseList.forEach((b) => remove(b));

  BookBase getBookBaseById(int isbn) => this.read(isbn);
}
