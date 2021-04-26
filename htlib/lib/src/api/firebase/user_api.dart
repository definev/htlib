import 'dart:developer';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/mode/mode.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/api/firebase/core/search_api.dart';
import 'package:htlib/src/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';

class FirebaseUserApi extends FirebaseCoreApi
    implements CRUDApi<User?>, SearchApi<User?> {
  FirebaseUserApi() : super(["${MODE}AppData", "${MODE}UserApi"]);

  Future<String> uploadImage(ImageFile? image, User user) async {
    if (!isContinue()) return "";
    String path = 'user/${user.address}${image!.extensions}';
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

  Future<void> removeImage(String? url) async {
    if (!isContinue()) return;
    await FirebaseStorage.instance.refFromURL(url!).delete();
  }

  @override
  Future<void> add(User? user) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["User"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;

    await dataBucket
        .doc("${user!.id}")
        .set(user.toJson(), SetOptions(merge: false));
  }

  @override
  Future<void> edit(User? user) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["User"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;

    await dataBucket
        .doc("${user!.id}")
        .set(user.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> addList(List<User?> userList) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["User"]) as Left<CollectionReference?, DocumentReference?>)
            .value;

    userList.forEach((user) async {
      await dataBucket!
          .doc("${user!.id}")
          .set(user.toJson(), SetOptions(merge: false));
    });
  }

  @override
  Future<void> remove(User? user) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["User"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;
    await dataBucket.doc("${user!.id}").delete();
    ;
  }

  @override
  Future<List<User>> getList() async {
    if (!isContinue()) return [];
    var dataBucket =
        (getData(["User"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;

    QuerySnapshot q = await dataBucket.get();
    List<User> res = q.docs.map<User>((e) => User.fromJson(e.data())).toList();

    return res;
  }

  @override
  Stream<List<User>> get stream {
    var dataBucket =
        (getData(["User"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;

    return dataBucket.snapshots().map(
          (snap) => snap.docs
              .map(
                (doc) => User.fromJson(doc.data()),
              )
              .toList(),
        );
  }

  @override
  Future<User?> getDataById(String id) async {
    var dataBucket = (getData(["User", "$id"])
            as Right<CollectionReference?, DocumentReference?>)
        .value!;
    DocumentSnapshot doc = await dataBucket.get();
    if (doc.data() != null) {
      var res = User.fromJson(Map<String, dynamic>.from(doc.data()!));
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
  Future<User?> query(String data) async {
    List<User> userList = (await getList()).where((e) {
      return e.id == data;
    }).toList();
    return userList.isEmpty ? null : userList.first;
  }

  @override
  Stream<User?> searchStream() {
    var dataBucket = (getData(["Search", "Query"])
            as Right<CollectionReference?, DocumentReference?>)
        .value!;
    return dataBucket.snapshots().asyncMap<User?>((event) async {
      log("PATH: ${dataBucket.path}\nHANDLE EVENT: ${event.data()!}",
          name: "USER_API");
      if (event.data()!["Query"] == "") return null;

      String? q = event.exists ? event.data()!["Query"] : null;
      if (q == "" || q == null) return null;
      User? user = await query(q);
      log("USERID: $q", name: "USER_API");
      return user;
    });
  }

  @override
  Future<void> addSearch(String data) async {
    var dataBucket = (getData(["Search", "Query"])
            as Right<CollectionReference?, DocumentReference?>)
        .value!;
    log("PATH: ${dataBucket.path}\nFIRE SEARCH DATA: ${data}",
        name: "USER_API");
    dataBucket.set({"Query": "$data"});
  }
}
