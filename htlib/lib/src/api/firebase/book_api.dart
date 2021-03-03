import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:htlib/src/api/core/book_api.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';

class FirebaseBookApi extends FirebaseCoreApi
    implements CRUDApi<Book>, BookApi {
  FirebaseBookApi() : super(["appData", "BookApi"]);

  @override
  Future<void> add(Book book) async {
    if (GetPlatform.isWindows) return;
    var dataBucket = (getData(["bookbase"]) as Left).value;
    await dataBucket.doc("${book.isbn}").set(
          book.toJson(),
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> remove(Book book) async {
    var dataBucket = (getData(["bookbase"]) as Left).value;
    await dataBucket.doc("${book.isbn}").delete();
  }

  @override
  Future<void> addList(List<Book> bookList) async {
    await bookList.forEach((book) async => await add(book));
  }

  @override
  Future<List<Book>> getList() async {
    var dataBucket = (getData(["bookbase"]) as Left).value;
    QuerySnapshot snapshot = await dataBucket.get();
    List<Book> res =
        snapshot.docs.map<Book>((e) => Book.fromJson(e.data())).toList();

    return res;
  }

  @override
  Stream<String> subscribeWaitingList() {
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
  Future<void> deleteWaitingList() {
    var dataBucket = getData(["waitingList"]);

    return dataBucket.fold(
        (l) => l.get().then(
              (query) => query.docs.forEach(
                (doc) async => await l.doc("${doc.id}").delete(),
              ),
            ),
        (r) => null);
  }

  @override
  Stream<List<Book>> get stream {
    throw Error.safeToString("Unimplement bookList");
  }

  @override
  Future<Book> getDataById(String id) async {
    var dataBucket = (getData(["bookbase", "$id"])
            as Right<CollectionReference, DocumentReference>)
        .value;
    DocumentSnapshot doc = await dataBucket.get();
    if (doc.data() != null) {
      var res = Book.fromJson(Map<String, dynamic>.from(doc.data()));
      return res;
    }
    return null;
  }
}
