import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/repositories/core_repo.dart';

class BookRepo extends CoreRepo {
  BookRepo() : super(["appData", "book"]);

  Future<void> addBookBase(BookBase bookBase) async {
    var dataBucket = getData(["bookbase"]);
    await dataBucket.fold((l) async {
      await l.doc("${bookBase.isbn}").set(bookBase.toJson());
    }, (r) {});
  }

  Future<void> deleteBookBase(BookBase bookBase) async {
    var dataBucket = getData(["bookbase"]);
    await dataBucket.fold((l) async {
      await l.doc("${bookBase.isbn}").delete();
    }, (r) {});
  }

  Future<void> addBookBaseList(List<BookBase> bookBaseList) async {
    var dataBucket = getData(["bookbase"]);
    await dataBucket.fold(
        (l) async => await bookBaseList
            .forEach((bookBase) async => await addBookBase(bookBase)),
        (r) {});
  }

  Future<List<BookBase>> getBookBaseList() async {
    var dataBucket = getData(["bookbase"]);
    return await dataBucket.fold((l) async {
      QuerySnapshot snapshot = await l.get();
      List<BookBase> bookBaseList = snapshot.docs
          .map<BookBase>((e) => BookBase.fromJson(e.data()))
          .toList();

      return bookBaseList;
    }, (r) => []);
  }

  Stream<String> getBarcodeStream() {
    var dataBucket = getData(["waitingList"]);
    return dataBucket.fold(
        (l) => l.snapshots().map<String>((query) {
              if (query.docs.isEmpty) return null;
              log(query.docChanges.first.oldIndex.toString());
              log(query.docChanges.first.newIndex.toString());
              log(query.docChanges.length.toString());
              return query.docChanges.first.doc.id;
            }),
        (r) => null);
  }

  Future<void> deleteAddList() {
    var dataBucket = getData(["waitingList"]);

    return dataBucket.fold(
        (l) => l.get().then(
              (query) => query.docs.forEach(
                (doc) async => await l.doc("${doc.id}").delete(),
              ),
            ),
        (r) => null);
  }
}
