import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/mode/mode.dart';
import 'package:htlib/src/api/core/book_api.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';

import 'core/search_api.dart';

class FirebaseBookApi extends FirebaseCoreApi
    implements CRUDApi<Book?>, BookApi, SearchApi<Book?> {
  FirebaseBookApi() : super(["${MODE}AppData", "${MODE}BookApi"]);

  @override
  Future<void> add(Book? book) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["Book"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;

    await dataBucket.doc("${book!.id}").set(
          book.toJson(),
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> edit(Book? book) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["Book"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;

    await dataBucket
        .doc("${book!.id}")
        .set(book.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> remove(Book? book) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["Book"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;
    await dataBucket.doc("${book!.id}").delete();
  }

  @override
  Future<void> addList(List<Book?> bookList) async {
    if (!isContinue()) return;
    bookList.forEach((book) async => await add(book));
  }

  @override
  Future<List<Book>> getList() async {
    if (!isContinue()) return [];
    var dataBucket =
        (getData(["Book"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;
    QuerySnapshot snapshot = await dataBucket.get();
    List<Book> res =
        snapshot.docs.map<Book>((e) => Book.fromJson(e.data()!)).toList();

    return res;
  }

  @override
  Stream<List<Book>> get stream {
    throw Error.safeToString("Unimplement bookList");
  }

  @override
  Future<Book?> getDataById(String id) async {
    var dataBucket = (getData(["Book", "$id"])
            as Right<CollectionReference?, DocumentReference?>)
        .value!;
    DocumentSnapshot doc = await dataBucket.get();
    if (doc.data() != null) {
      var res = Book.fromJson(Map<String, dynamic>.from(doc.data()!));
      return res;
    }
    return null;
  }

  @override
  Future<void> onSearchDone() async {
    var dataBucket = (getData(["Search", "Query"])
            as Right<CollectionReference?, DocumentReference?>)
        .value!;
    await dataBucket.set({"Query": ""});
  }

  @override
  Future<Book?> query(String data) async {
    List<Book> bookList = (await getList()).where((e) => e.id == data).toList();
    return bookList.isEmpty ? null : bookList.first;
  }

  @override
  Stream<Book?> searchStream() {
    var dataBucket = (getData(["Search", "Query"])
            as Right<CollectionReference?, DocumentReference?>)
        .value!;
    return dataBucket.snapshots().asyncMap<Book?>((event) async {
      String? q = event.exists ? event.data()!["Query"] : null;

      if (q == "" || q == null) return null;
      Book? book = await query(q);
      if (book != null) await onSearchDone();
      log("$q", name: "BOOK_API");
      return book;
    });
  }

  @override
  Future<void> addSearch(String data) async {
    var dataBucket = (getData(["Search", "Query"])
            as Right<CollectionReference?, DocumentReference?>)
        .value!;
    dataBucket.set({"Query": "$data"});
  }
}
