import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';

import 'core/err/firebase_error.dart';

class FirebaseUserApi extends FirebaseCoreApi implements CRUDApi<User> {
  FirebaseUserApi() : super(["appData", "UserApi"]);

  @override
  Future<void> add(User user) async {
    var dataBucket = (getData(["User"]) as Left).value;

    dataBucket
        .doc("${user.id}")
        .set(user.toJson(), SetOptions(merge: false))
        .then(
          (value) => right(unit),
          onError: () => left(NetworkError()),
        );
  }

  @override
  Future<void> addList(List<User> userList) async {
    var dataBucket = (getData(["User"]) as Left).value;

    await userList.forEach((user) async {
      await dataBucket
          .doc("${user.id}")
          .set(user.toJson(), SetOptions(merge: false))
          .then(
            (value) => right(unit),
            onError: () => left(NetworkError()),
          );
    });
  }

  @override
  Future<void> remove(User user) async {
    var dataBucket = (getData(["User"]) as Left).value;
    await dataBucket.doc("${user.id}").delete();
    ;
  }

  @override
  Future<List<User>> getList() async {
    var dataBucket = (getData(["User"]) as Left).value;

    QuerySnapshot q = await dataBucket.get();
    List<User> res = q.docs.map((e) => User.fromJson(e.data())).toList();

    return res;
  }

  @override
  Stream<List<User>> get stream {
    var dataBucket = (getData(["User"]) as Left).value;

    return dataBucket.snapshots().map(
          (snap) => snap.docs
              .map(
                (doc) => User.fromJson(doc.data()),
              )
              .toList(),
        );
  }

  @override
  Future<User> getDataById(String id) async {
    var dataBucket = (getData(["User", "$id"]) as Right).value;
    DocumentSnapshot doc = await dataBucket.get();
    if (doc.data() != null) {
      var res = User.fromJson(Map<String, dynamic>.from(doc.data()));
      return res;
    }
    return null;
  }
}
