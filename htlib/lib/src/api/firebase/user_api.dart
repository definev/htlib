import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htlib/src/api/core/user_api.dart';
import 'package:htlib/src/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';

import 'core/err/firebase_error.dart';

class FirebaseUserApi extends FirebaseCoreApi implements UserApi {
  FirebaseUserApi() : super(["appData", "FirebaseUserApi"]);

  @override
  Future<Either<Error, Unit>> add(User user) async {
    var dataBucket = getData(["user"]);
    return await dataBucket.fold(
      (l) async => await l
          .doc("${user.id}")
          .set(user.toJson(), SetOptions(merge: false))
          .then(
            (value) => right(unit),
            onError: () => left(NetworkError()),
          ),
      (r) => left(UnexpectedBucketHandleError()),
    );
  }

  @override
  Future<Either<Error, Unit>> edit(User user) async {
    var dataBucket = getData(["user"]);
    return await dataBucket.fold(
      (l) async {
        try {
          await l.doc("${user.id}").set(user.toJson());
          return right(unit);
        } catch (e) {
          return left(NetworkError());
        }
      },
      (r) => left(UnexpectedBucketHandleError()),
    );
  }

  @override
  Future<Either<Error, Unit>> delete(User user) async {
    var dataBucket = getData(["user"]);
    return await dataBucket.fold(
      (l) async {
        try {
          await l.doc("${user.id}").delete();
          return right(unit);
        } catch (e) {
          return left(NetworkError());
        }
      },
      (r) => left(UnexpectedBucketHandleError()),
    );
  }

  @override
  Future<Either<Error, List<User>>> getList() async {
    var dataBucket = getData(["user"]);
    return await dataBucket.fold(
      (l) async {
        try {
          QuerySnapshot q = await l.get();
          if (q != null) {
            return right(q.docs.map((e) => User.fromJson(e.data())).toList());
          } else {
            return left(NetworkError());
          }
        } catch (e) {
          return left(NetworkError());
        }
      },
      (r) => left(UnexpectedBucketHandleError()),
    );
  }

  @override
  Stream<List<User>> subscribe() {
    var dataBucket = getData(["user"]);
    return dataBucket.fold(
      (l) => l.snapshots().map(
            (snap) => snap.docs
                .map(
                  (doc) => User.fromJson(doc.data()),
                )
                .toList(),
          ),
      (r) => throw UnexpectedBucketHandleError(),
    );
  }
}
