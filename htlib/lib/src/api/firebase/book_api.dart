import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/src/api/core/book_api.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';

class FirebaseBookApi extends FirebaseCoreApi
    implements CRUDApi<Book>, BookApi {
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
}
