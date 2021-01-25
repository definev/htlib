import 'package:htlib/app/data/book_base.dart';

abstract class IBookRepo {
  Future<void> add(BookBase bookBase);

  Future<void> remove(BookBase bookBase);

  Future<void> addList(List<BookBase> bookBaseList);

  Future<List<BookBase>> getList();

  Stream<String> getBarcodeStream();

  Future<void> deleteAddList();
}
