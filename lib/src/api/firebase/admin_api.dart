import 'dart:developer';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/mode/mode.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/utils/class_utils.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/firebase_core_api.dart';

class FirebaseAdminApi extends FirebaseCoreApi implements CRUDApi<AdminUser> {
  FirebaseAdminApi() : super(["${MODE}AppData", "${MODE}AdminApi"]);

  Future<String> uploadMornitorImage(ImageFile image, AdminUser user) async {
    if (!isContinue()) return "https://thispersondoesnotexist.com/image";
    String path = 'admin/mornitor/${user.className! + "-" + user.email + "-" + user.uid}${image.extensions}';
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

  Future<bool> isLibrarian() async {
    if (!isContinue()) return true;
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }

    var user = FirebaseAuth.instance.currentUser!;
    var dataBucket =
        (getData(["Librarian", "${user.email}"]) as Right<CollectionReference?, DocumentReference?>).value!;

    var data = await dataBucket.get();
    return data.exists;
  }

  Future<bool> isMornitor() async {
    if (!isContinue()) return true;
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }

    var user = FirebaseAuth.instance.currentUser!;
    var dataBucket = (getData(["Mornitor", "${user.email}"]) as Right<CollectionReference?, DocumentReference?>).value!;

    var data = await dataBucket.get();
    return data.exists;
  }

  Future<bool> addMornitor(AdminUser user) async {
    if (!isContinue()) return true;
    try {
      var data = await FirebaseFirestore.instance
          .collection("${MODE}AppData")
          .doc("${MODE}AdminApi")
          .collection("Mornitor")
          .where("className", isEqualTo: user.className)
          .get();

      data.docs.forEach((doc) async {
        FirebaseStorage.instance.refFromURL(doc.data()['imageUrl']).delete();
        await FirebaseFirestore.instance
            .collection("${MODE}AppData")
            .doc("${MODE}AdminApi")
            .collection("Mornitor")
            .doc(doc.id)
            .delete();
      });

      var dataBucket = getData(["Mornitor", "${user.email}"]) as Right<CollectionReference?, DocumentReference?>;
      await dataBucket.value!.set(user.toJson());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> editMornitor(AdminUser user) async {
    if (!isContinue()) return true;
    try {
      await add(user);
      var dataBucket = getData(["Mornitor", "${user.email}"]) as Right<CollectionReference?, DocumentReference?>;

      await dataBucket.value!.update(user.toJson());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteMornitor(AdminUser user) async {
    if (!isContinue()) return true;
    try {
      await add(user);
      var dataBucket = getData(["Mornitor", "${user.email}"]) as Right<CollectionReference?, DocumentReference?>;

      await dataBucket.value!.delete();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<AdminUser>> getListMornitor() async {
    var collection = await FirebaseFirestore.instance
        .collection("${MODE}AppData")
        .doc("${MODE}AdminApi")
        .collection("Mornitor")
        .get();

    return collection.docs.map((doc) => AdminUser.fromJson(doc.data())).toList();
  }

  Future<List<List<AdminUser?>>> getAllMornitor() async {
    try {
      DateTime now = DateTime.now();

      List<List<AdminUser?>> res = List.generate(
        now.year - ClassUtils.firstYearOfBirth - 15,
        (index) => List.generate(ClassUtils.maxClassNumber, (index) => null),
      );

      var collection = await FirebaseFirestore.instance
          .collection("${MODE}AppData")
          .doc("${MODE}AdminApi")
          .collection("Mornitor")
          .get();

      for (final doc in collection.docs) {
        final user = AdminUser.fromJson(doc.data());
        final matrix = ClassUtils.parseClassNameToMatrix(user.className!);

        res[matrix.value1][matrix.value2] = user;
      }

      return res;
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      DateTime now = DateTime.now();

      return List.generate(
        now.year - ClassUtils.firstYearOfBirth - 15,
        (index) => List.generate(ClassUtils.maxClassNumber, (index) => null),
      );
    }
  }

  Stream<List<List<AdminUser?>>> get allMornitorStream {
    return FirebaseFirestore.instance
        .collection("${MODE}AppData")
        .doc("${MODE}AdminApi")
        .collection("Mornitor")
        .snapshots()
        .asyncMap((collection) async {
      DateTime now = DateTime.now();

      List<List<AdminUser?>> res = List.generate(
        now.year - ClassUtils.firstYearOfBirth - 15,
        (index) => List.generate(ClassUtils.maxClassNumber, (index) => null),
      );

      var collection = await FirebaseFirestore.instance
          .collection("${MODE}AppData")
          .doc("${MODE}AdminApi")
          .collection("Mornitor")
          .get();

      for (final doc in collection.docs) {
        final user = AdminUser.fromJson(doc.data());
        final matrix = ClassUtils.parseClassNameToMatrix(user.className!);

        res[matrix.value1][matrix.value2] = user;
      }

      return res;
    });
  }

  @override
  Future<void> add(AdminUser data) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["Librarian", "${data.email}"]) as Right<CollectionReference?, DocumentReference?>).value!;
    await dataBucket.set(data.toJson(), SetOptions(merge: false));
  }

  @override
  Future<void> edit(AdminUser data) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["Librarian", "${data.email}"]) as Right<CollectionReference?, DocumentReference?>).value!;

    await dataBucket.set(data.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> remove(AdminUser data) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["Librarian", "${data.email}"]) as Right<CollectionReference?, DocumentReference?>).value!;
    await dataBucket.delete();
  }

  @override
  Future<void> addList(List<AdminUser> dataList) async {
    if (!isContinue()) return;
    dataList.forEach((data) async => await add(data));
  }

  @override
  Future<List<AdminUser>> getList() async {
    if (!isContinue()) return [];
    var dataBucket = (getData(["Librarian"]) as Left<CollectionReference?, DocumentReference?>).value!;
    QuerySnapshot snapshot = await dataBucket.get();
    List<AdminUser> res = snapshot.docs.map<AdminUser>((e) => AdminUser.fromJson(e.data())).toList();

    return res;
  }

  @override
  Future<AdminUser?> getDataById(String id) async {
    var dataBucket = (getData(["Librarian", "$id"]) as Right<CollectionReference?, DocumentReference?>).value!;
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
