import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/src/api/core/book_api.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';

import 'core/search_api.dart';

class FirebaseBookApi extends FirebaseCoreApi
    implements CRUDApi<Book>, BookApi, SearchApi<Book> {
  FirebaseBookApi() : super(["appData", "BookApi"]);

  @override
  Future<void> add(Book book) async {
    if (!isContinue()) return;
    var dataBucket = (getData(["Book"]) as Left).value;
    await dataBucket.doc("${book.isbn}").set(
          book.toJson(),
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> edit(Book book) async {
    if (!isContinue()) return;
    var dataBucket = (getData(["Book"]) as Left).value;

    await dataBucket
        .doc("${book.isbn}")
        .set(book.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> remove(Book book) async {
    if (!isContinue()) return;
    var dataBucket = (getData(["Book"]) as Left).value;
    await dataBucket.doc("${book.isbn}").delete();
  }

  @override
  Future<void> addList(List<Book> bookList) async {
    if (!isContinue()) return;
    await bookList.forEach((book) async => await add(book));
  }

  @override
  Future<List<Book>> getList() async {
    if (!isContinue()) return [];
    var dataBucket = (getData(["Book"]) as Left).value;
    QuerySnapshot snapshot = await dataBucket.get();
    List<Book> res =
        snapshot.docs.map<Book>((e) => Book.fromJson(e.data())).toList();

    return res;
  }

  @override
  Stream<List<Book>> get stream {
    throw Error.safeToString("Unimplement bookList");
  }

  @override
  Future<Book> getDataById(String id) async {
    var dataBucket = (getData(["Book", "$id"])
            as Right<CollectionReference, DocumentReference>)
        .value;
    DocumentSnapshot doc = await dataBucket.get();
    if (doc.data() != null) {
      var res = Book.fromJson(Map<String, dynamic>.from(doc.data()));
      return res;
    }
    return null;
  }

  @override
  Future<void> onSearchDone() async {
    var dataBucket =
        (getData(["Search"]) as Left<CollectionReference, DocumentReference>)
            .value;
    await dataBucket.doc().set({"Query": ""});
  }

  @override
  Future<Book> query(String data) async {
    return (await getList()).where((e) => e.isbn == query).first;
  }

  @override
  Stream<Book> searchStream() {
    var dataBucket = (getData(["Search", "Query"])
            as Right<CollectionReference, DocumentReference>)
        .value;
    return dataBucket.snapshots().asyncMap<Book>((event) async {
      String q = event.data()["Query"];

      if (query == "") return null;
      Book user = await query(q);
      if (user != null) await onSearchDone();
      return user;
    });
  }

  @override
  Future<void> addSearch(String data) async {
    var dataBucket = (getData(["Search", "Query"])
            as Right<CollectionReference, DocumentReference>)
        .value;
    dataBucket.set({"Query": "$data"});
  }
}
