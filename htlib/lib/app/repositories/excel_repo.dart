import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/repositories/core_repo.dart';

class ExcelRepo extends CoreRepo {
  ExcelRepo() : super(["appData", "excel"]);

  bool _isFirstCall = true;
  set isFirstCall(bool value) => _isFirstCall = value;

  Future<void> addBookBase(BookBase bookBase) async {
    var dataBucket = getData(["bookbase"]);
    await dataBucket.fold((l) async {
      await l.doc("${bookBase.id}").set(bookBase.toJson());
    }, (r) {});
  }

  Future<void> deleteBookBase(BookBase bookBase) async {
    var dataBucket = getData(["bookbase"]);
    await dataBucket.fold((l) async {
      await l.doc("${bookBase.id}").delete();
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

  Stream<int> getAddListStream() {
    var dataBucket = getData(["waitingList"]);
    return dataBucket.fold(
        (l) => l.snapshots().map<int>((query) {
              if (query.docs.isEmpty) return null;
              if (_isFirstCall) {
                _isFirstCall = false;
                return null;
              }
              log(query.docChanges.first.oldIndex.toString());
              log(query.docChanges.first.newIndex.toString());
              log(query.docChanges.length.toString());
              if (query.docChanges.first.oldIndex <
                  query.docChanges.first.newIndex) {
                print(query.docChanges.first.doc.id);
                return int.parse(query.docChanges.first.doc.id);
              }

              return null;
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
