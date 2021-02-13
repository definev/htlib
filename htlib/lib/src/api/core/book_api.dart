import 'package:htlib/src/model/book_base.dart';

abstract class BookApi {
  Future<void> add(BookBase bookBase);

  Future<void> remove(BookBase bookBase);

  Future<void> addList(List<BookBase> bookBaseList);

  Future<List<BookBase>> getList();

  Stream<String> subscribeWaitingList();

  Future<void> deleteWaitingList();
}
