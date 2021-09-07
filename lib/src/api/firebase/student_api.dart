import 'dart:developer';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/mode/mode.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';
import 'package:htlib/src/model/user.dart';

class FirebaseStudentApi extends FirebaseCoreApi implements CRUDApi<User> {
  FirebaseStudentApi() : super(["${MODE}AppData", "${MODE}StudentApi"]);

  Future<String> uploadImage(ImageFile? image, User user) async {
    if (!isContinue()) return "";
    String path = 'student/${user.className}/${user.id}.${image!.extensions}';
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

  Future<void> removeImage(String url) async {
    if (!isContinue()) return;
    await FirebaseStorage.instance.refFromURL(url).delete();
  }

  @override
  Future<void> add(User user) async => await FirebaseFirestore.instance
      .collection("${MODE}AppData")
      .doc("${MODE}StudentApi")
      .collection("Students")
      .doc(user.id)
      .set(user.toJson(), SetOptions(merge: false));

  @override
  Future<void> edit(User user) async => await FirebaseFirestore.instance
      .collection("${MODE}AppData")
      .doc("${MODE}StudentApi")
      .collection("Students")
      .doc(user.id)
      .set(user.toJson(), SetOptions(merge: true));

  @override
  Future<void> remove(User user) async => await FirebaseFirestore.instance
      .collection("${MODE}AppData")
      .doc("${MODE}StudentApi")
      .collection("Students")
      .doc(user.id)
      .delete();

  Future<List<User>> getList() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("${MODE}AppData")
        .doc("${MODE}StudentApi")
        .collection("Students")
        .get();

    final res = snapshot.docs.map((doc) => User.fromJson(Map.from(doc.data()))).toList();
    return res;
  }

  Future<List<User>> getClassList(String className) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("${MODE}AppData")
        .doc("${MODE}StudentApi")
        .collection("Students")
        .where('className', isEqualTo: className)
        .get();

    return snapshot.docs.map((doc) => User.fromJson(Map.from(doc.data()))).toList();
  }

  @override
  Future<User?> getDataById(String id) {
    throw UnimplementedError();
  }

  Future<User?> getDataByPhone(String phone) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("${MODE}AppData")
        .doc("${MODE}StudentApi")
        .collection("Students")
        .where('phone', isEqualTo: phone)
        .get();

    if (snapshot.docs.isNotEmpty) return User.fromJson(snapshot.docs.first.data());
    return null;
  }

  @override
  Future<void> addList(List<User> userList) async {
    for (int index = 0; index < userList.length; index++) {
      await add(userList[index]);
    }
  }

  @override
  Stream<List<User>> get stream {
    var dataBucket = (getData(["User"]) as Left<CollectionReference?, DocumentReference?>).value!;
    return dataBucket.snapshots().map((snap) => snap.docs.map((doc) => User.fromJson(doc.data())).toList());
  }

  Future<void> onSearchDone() async {
    var dataBucket = (getData([]) as Right<CollectionReference, DocumentReference>).value;
    await dataBucket.set({"Query": ""});
  }

  // Only use with [AdminType.librarian]
  Future<User?> query(String data) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("${MODE}AppData")
        .doc("${MODE}StudentApi")
        .collection("Students")
        .where('id', isEqualTo: data)
        .get();
    ;
    List<User> userList = snapshot.docs.map((e) => User.fromJson(e.data())).toList();
    return userList.isEmpty ? null : userList.first;
  }

  Stream<User?> get searchStream {
    var dataBucket = (getData(["Search", "Query"]) as Right<CollectionReference?, DocumentReference?>).value!;
    return dataBucket.snapshots().asyncMap<User?>((event) async {
      if (event.exists) {
        log("PATH: ${dataBucket.path}\nHANDLE EVENT: ${event.data()!}", name: "USER_API");
        if (event.data()!["Query"] == "") return null;

        String? queryStatement = event.exists ? event.data()!["Query"] : null;
        if (queryStatement == "" || queryStatement == null) return null;
        User? user = await query(queryStatement);
        log("USERID: $queryStatement", name: "USER_API");
        return user;
      }
    });
  }

  Future<void> addSearch(String data) async {
    var dataBucket = (getData(["Search", "Query"]) as Right<CollectionReference?, DocumentReference?>).value!;
    log("PATH: ${dataBucket.path}\nFIRE SEARCH DATA: ${data}", name: "USER_API");
    dataBucket.set({"Query": "$data"});
  }
}
