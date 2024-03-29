import 'dart:developer';

import 'package:universal_io/io.dart' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/mode/mode.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/admin_user.dart';

import 'core/firebase_core_api.dart';

class FirebaseAdminApi extends FirebaseCoreApi implements CRUDApi<AdminUser> {
  FirebaseAdminApi() : super(["${MODE}AppData", "${MODE}AdminApi"]);

  Future<String> uploadMornitorImage(ImageFile image, AdminUser user) async {
    if (!isContinue()) return "";
    String path = 'admin/mornitor/${user.email + user.uid}${image.extensions}';
    Reference storageReference = FirebaseStorage.instance.ref().child(path);
    String url;
    if (kIsWeb) {
      UploadTask uploadTask = storageReference.putBlob(image.webImage);
      TaskSnapshot snapshot = await uploadTask;
      url = await snapshot.ref.getDownloadURL();
      log("EXT: ${image.extensions}, DOWNLOAD URL: $url");
    } else {
      io.File img = io.File("${image.image!.path}");
      UploadTask uploadTask = storageReference.putFile(img);
      TaskSnapshot snapshot = await uploadTask;
      url = await snapshot.ref.getDownloadURL();
      log("EXT: ${image.extensions}, DOWNLOAD URL: $url");
    }
    return url;
  }

  Future<bool> isAdmin() async {
    if (!isContinue()) return true;
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    } else {
      var user = FirebaseAuth.instance.currentUser!;
      var dataBucket = (getData(["Admin", "${user.email}"]) as Right<CollectionReference?, DocumentReference?>).value!;

      var data = await dataBucket.get();
      return data.exists;
    }
  }

  Future<bool> addMornitor({
    required int grade,
    required int classNumber,
    required AdminUser user,
  }) async {
    if (!isContinue()) return true;
    try {
      await add(user);
      var dataBucket = getData(["Grade-$grade", "${grade}A${classNumber}"]) as Right<CollectionReference?, DocumentReference?>;

      await dataBucket.value!.set(user.toJson());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> editMornitor({
    required int grade,
    required int classNumber,
    required AdminUser user,
  }) async {
    if (!isContinue()) return true;
    try {
      await add(user);
      var dataBucket = getData(["Grade-$grade", "${grade}A${classNumber}"]) as Right<CollectionReference?, DocumentReference?>;

      await dataBucket.value!.update(user.toJson());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteMornitor({
    required int grade,
    required int classNumber,
    required AdminUser user,
  }) async {
    if (!isContinue()) return true;
    try {
      await add(user);
      var dataBucket = getData(["Grade-$grade", "${grade}A${classNumber}"]) as Right<CollectionReference?, DocumentReference?>;

      await dataBucket.value!.delete();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<List<AdminUser?>>> getAllMornitor() async {
    List<List<AdminUser?>> res = [
      List.generate(15, (index) => null),
      List.generate(15, (index) => null),
      List.generate(15, (index) => null),
    ];

    if (!isContinue()) return res;

    for (int grade = 10; grade <= 12; grade++) {
      var dataBucket = getData(["Grade-$grade"]) as Left<CollectionReference?, DocumentReference?>;

      var snapshot = await dataBucket.value!.get();
      for (final doc in snapshot.docs) {
        var data = doc.id.split('A');
        if (data.isNotEmpty) {
          int className = (int.tryParse(data.last) ?? 0) - 1;
          if (className != -1) {
            res[2 - (12 - grade)][className] = AdminUser.fromJson(doc.data());
          }
        }
      }
    }

    return res;
  }

  @override
  Future<void> add(AdminUser data) async {
    if (!isContinue()) return;
    var dataBucket = (getData(["Admin"]) as Left<CollectionReference?, DocumentReference?>).value!;

    await dataBucket.doc("${data.email}").set(data.toJson(), SetOptions(merge: false));
  }

  @override
  Future<void> edit(AdminUser data) async {
    if (!isContinue()) return;
    var dataBucket = (getData(["Admin"]) as Left<CollectionReference?, DocumentReference?>).value!;

    await dataBucket.doc("${data.email}").set(data.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> remove(AdminUser data) async {
    if (!isContinue()) return;
    var dataBucket = (getData(["Admin"]) as Left<CollectionReference?, DocumentReference?>).value!;
    await dataBucket.doc("${data.email}").delete();
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
