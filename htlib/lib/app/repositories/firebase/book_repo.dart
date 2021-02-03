import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/repositories/firebase/core_repo.dart';
import 'package:htlib/app/repositories/interface/i_book_repo.dart';

class BookRepo extends CoreRepo with IBookRepo {
  BookRepo() : super(["appData", "BookRepo"]);

  @override
  Future<void> add(BookBase bookBase) async {
    if (GetPlatform.isWindows) return;
    var dataBucket = getData(["bookbase"]);
    await dataBucket.fold((l) async {
      await l.doc("${bookBase.isbn}").set(
            bookBase.toJson(),
            SetOptions(merge: true),
          );
    }, (r) {});
  }

  @override
  Future<void> remove(BookBase bookBase) async {
    var dataBucket = getData(["bookbase"]);
    await dataBucket.fold((l) async {
      await l.doc("${bookBase.isbn}").delete();
    }, (r) {});
  }

  @override
  Future<void> addList(List<BookBase> bookBaseList) async {
    var dataBucket = getData(["bookbase"]);
    await dataBucket.fold(
        (l) async =>
            await bookBaseList.forEach((bookBase) async => await add(bookBase)),
        (r) {});
  }

  @override
  Future<List<BookBase>> getList() async {
    var dataBucket = getData(["bookbase"]);
    return await dataBucket.fold((l) async {
      QuerySnapshot snapshot = await l.get();
      List<BookBase> bookBaseList = snapshot.docs
          .map<BookBase>((e) => BookBase.fromJson(e.data()))
          .toList();

      return bookBaseList;
    }, (r) => []);
  }

  @override
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

  @override
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
