import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/mode/mode.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';
import 'package:htlib/src/model/comment.dart';

class FirebaseBookCommentApi extends FirebaseCoreApi
    implements CRUDApi<Comment> {
  FirebaseBookCommentApi(this.bookId)
      : super(["${MODE}AppData", "${MODE}BookCommentApi"]);

  final String bookId;

  @override
  Future<void> add(Comment data) async {
    final doc = getData([bookId, data.id])
        as Right<CollectionReference, DocumentReference>;
    await doc.value.set(data.toMap());
  }

  @override
  Future<void> addList(List<Comment> dataList) async {
    for (final data in dataList) {
      await add(data);
    }
  }

  @override
  Future<void> edit(Comment data) async {
    final doc = getData([bookId, data.id])
        as Right<CollectionReference, DocumentReference>;
    await doc.value.set(data.toMap(), SetOptions(merge: true));
  }

  @override
  Future<Comment?> getDataById(String id) async {
    final doc =
        getData([bookId, id]) as Right<CollectionReference, DocumentReference>;
    final data = await doc.value.get();
    return data.exists ? Comment.fromMap(data.data()!) : null;
  }

  @override
  Future<List<Comment>> getList() async {
    final col =
        getData([bookId]) as Left<CollectionReference, DocumentReference>;
    final data = await col.value.orderBy('createdAt', descending: true).get();
    List<Comment> comments = [];
    for (final doc in data.docs) {
      comments.add(Comment.fromMap(doc.data()));
    }
    return comments;
  }

  @override
  Future<void> remove(Comment data) async {
    final doc = getData([bookId, data.id])
        as Right<CollectionReference, DocumentReference>;
    await doc.value.delete();
  }

  @override
  Stream<List<Comment>> get stream {
    final col =
        getData([bookId]) as Left<CollectionReference, DocumentReference>;
    return col.value.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Comment.fromMap(doc.data())).toList(),
        );
  }
}
