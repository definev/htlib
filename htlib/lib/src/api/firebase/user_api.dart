import 'dart:developer';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';

import 'core/err/firebase_error.dart';

class FirebaseUserApi extends FirebaseCoreApi implements CRUDApi<User> {
  FirebaseUserApi() : super(["appData", "UserApi"]);

  Future<String> uploadImage(ImageFile image, User user) async {
    String path = 'user/${user.idNumberCard}${image.extensions}';
    Reference storageReference = FirebaseStorage.instance.ref().child(path);
    String url;
    if (kIsWeb) {
      UploadTask uploadTask = storageReference.putBlob(image.webImage);
      TaskSnapshot snapshot = await uploadTask;
      url = await snapshot.ref.getDownloadURL();
      log("EXT: ${image.extensions}, DOWNLOAD URL: $url");
    } else {
      io.File img = io.File("${image.image.path}");
      UploadTask uploadTask = storageReference.putFile(img);
      TaskSnapshot snapshot = await uploadTask;
      url = await snapshot.ref.getDownloadURL();
      log("EXT: ${image.extensions}, DOWNLOAD URL: $url");
    }
    return url;
  }

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
    List<User> res = q.docs.map<User>((e) => User.fromJson(e.data())).toList();

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
