import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:htlib/mode/mode.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/admin_user.dart';

import 'core/firebase_core_api.dart';

class FirebaseAdminApi extends FirebaseCoreApi implements CRUDApi<AdminUser> {
  FirebaseAdminApi() : super(["${MODE}AppData", "${MODE}AdminApi"]);

  Future<bool> isAdmin() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    } else {
      var user = FirebaseAuth.instance.currentUser!;
      var dataBucket = (getData(["Admin", "${user.email}"]) as Right<CollectionReference?, DocumentReference?>).value!;

      var data = await dataBucket.get();
      return data.exists;
    }
  }

  @override
  Future<void> add(AdminUser data) async {
    if (!isContinue()) return;
    var dataBucket = (getData(["Admin"]) as Left<CollectionReference?, DocumentReference?>).value!;

    await dataBucket.doc("${data.uid}").set(data.toJson(), SetOptions(merge: false));
  }

  @override
  Future<void> edit(AdminUser data) async {
    if (!isContinue()) return;
    var dataBucket = (getData(["Admin"]) as Left<CollectionReference?, DocumentReference?>).value!;

    await dataBucket.doc("${data.uid}").set(data.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> remove(AdminUser data) async {
    if (!isContinue()) return;
    var dataBucket = (getData(["Admin"]) as Left<CollectionReference?, DocumentReference?>).value!;
    await dataBucket.doc("${data.uid}").delete();
  }

  @override
  Future<void> addList(List<AdminUser> dataList) async {
    if (!isContinue()) return;
    dataList.forEach((data) async => await add(data));
  }

  @override
  Future<List<AdminUser>> getList() async {
    if (!isContinue()) return [];
    var dataBucket = (getData(["Admin"]) as Left<CollectionReference?, DocumentReference?>).value!;
    QuerySnapshot snapshot = await dataBucket.get();
    List<AdminUser> res = snapshot.docs.map<AdminUser>((e) => AdminUser.fromJson(e.data())).toList();

    return res;
  }

  @override
  Future<AdminUser?> getDataById(String id) async {
    var dataBucket = (getData(["Admin", "$id"]) as Right<CollectionReference?, DocumentReference?>).value!;
    DocumentSnapshot doc = await dataBucket.get();
    if (doc.data() != null) {
      var res = AdminUser.fromJson(Map<String, dynamic>.from(doc.data()!));
      return res;
    }
    return null;
  }

  @override
  Stream<List<AdminUser>> get stream => throw Error.safeToString("Unimplement adminList");
}
