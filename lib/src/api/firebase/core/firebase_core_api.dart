import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

bool isContinue() {
  if (GetPlatform.isDesktop && !kIsWeb) return false;
  return true;
}

abstract class FirebaseCoreApi {
  FirebaseFirestore? get firestore {
    if (GetPlatform.isWindows) return null;
    return FirebaseFirestore.instance;
  }

  final List<String> corePath;

  FirebaseCoreApi(this.corePath);

  Either<CollectionReference, DocumentReference> getData(List<String> path) {
    path = path.reversed.toList()..addAll(corePath.reversed);
    path = path.reversed.toList();
    CollectionReference? col;
    DocumentReference? doc;
    for (int i = 0; i < path.length; i++) {
      if (i % 2 == 0) {
        col = doc == null ? FirebaseFirestore.instance.collection(path[i]) : doc.collection(path[i]);
      } else {
        doc = col!.doc(path[i]);
      }
    }
    if (path.length % 2 == 1) {
      return left(col!);
    } else {
      return right(doc!);
    }
  }
}
