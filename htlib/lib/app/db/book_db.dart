import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/db/core_db.dart';

import '../data/book_base.dart';

class BookDb extends CoreDb {
  BookDb() : super("BookDb", adapter: [BookBaseAdapter()]);

  List<BookBase> get currentBookBaseList {
    List<BookBase> res = this
        .box
        .values
        .where((e) {
          if (e is BookBase) {
            return true;
          }
          return false;
        })
        .toList()
        .cast();

    return res;
  }

  void addBookBase(BookBase bookBase) => this.write(bookBase.id, bookBase);

  void addBookBaseList(List<BookBase> bookBaseList, {bool override = false}) {
    bookBaseList.forEach((bookBase) {
      if (override == false) {
        bool inDb = this.box.values.contains(bookBase);
        if (!inDb) addBookBase(bookBase);
      } else {
        addBookBase(bookBase);
      }
    });
  }

  void setBookBaseList(List<BookBase> bookBaseList) {
    bookBaseList.forEach((bookBase) => this.write(bookBase.id, bookBase));
  }

  void deleteBookBase(BookBase bookBase) => this.delete(bookBase.id);

  void deleteBookBaseList(List<BookBase> bookBaseList) =>
      bookBaseList.forEach((b) => deleteBookBase(b));

  BookBase getBookBaseById(int id) => this.read(id);
}
