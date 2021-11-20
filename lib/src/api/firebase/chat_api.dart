import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/mode/mode.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';
import 'package:htlib/src/model/notification.dart';

class FirebaseChatApi extends FirebaseCoreApi implements CRUDApi<ChatMessage> {
  FirebaseChatApi(
    this.senderId,
    this.receiverId,
  ) : super(["${MODE}AppData", "${MODE}ChatApi"]) {
    for (int i = 0; i < senderId.length; i++) {
      bindId += senderId[i].compareTo(receiverId[i]) < 0
          ? senderId[i]
          : receiverId[i];
    }
  }

  final String senderId;
  final String receiverId;
  late String bindId;

  @override
  Future<void> add(ChatMessage data) async {
    final doc = getData([bindId, data.id])
        as Right<CollectionReference, DocumentReference>;
    await doc.value.set(data.toMap());
  }

  @override
  Future<void> addList(List<ChatMessage> dataList) async {
    for (final data in dataList) {
      await add(data);
    }
  }

  @override
  Future<void> edit(ChatMessage data) async {
    final doc = getData([bindId, data.id])
        as Right<CollectionReference, DocumentReference>;
    await doc.value.set(data.toMap(), SetOptions(merge: true));
  }

  @override
  Future<ChatMessage?> getDataById(String id) async {
    final doc =
        getData([bindId, id]) as Right<CollectionReference, DocumentReference>;
    final data = await doc.value.get();
    return data.exists ? ChatMessage.fromMap(data.data()!) : null;
  }

  @override
  Future<List<ChatMessage>> getList() async {
    final col =
        getData([bindId]) as Left<CollectionReference, DocumentReference>;
    final data = await col.value.orderBy('createdAt', descending: true).get();
    List<ChatMessage> comments = [];
    for (final doc in data.docs) {
      comments.add(ChatMessage.fromMap(doc.data()));
    }
    return comments;
  }

  @override
  Future<void> remove(ChatMessage data) async {
    final doc = getData([bindId, data.id])
        as Right<CollectionReference, DocumentReference>;
    await doc.value.delete();
  }

  @override
  Stream<List<ChatMessage>> get stream {
    final col =
        getData([bindId]) as Left<CollectionReference, DocumentReference>;
    return col.value.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromMap(doc.data()))
              .toList(),
        );
  }
}
