import 'package:htlib/app/data/user.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/app/repositories/err/firebase_error.dart';
import 'package:htlib/app/repositories/firebase/core_repo.dart';
import 'package:htlib/app/repositories/interface/i_user_repo.dart';

class UserRepo extends CoreRepo with IUserRepo {
  UserRepo() : super(["appData", "UserRepo"]);

  @override
  Future<Either<Error, Unit>> addUser(User user) async {
    var dataBucket = getData(["user"]);
    return await dataBucket.fold(
      (l) async => await l.doc("${user.id}").set(user.toJson()).then(
            (value) => right(unit),
            onError: () => left(NetworkError()),
          ),
      (r) => left(UnexpectedBucketHandleError()),
    );
  }

  @override
  Future<Either<Error, Unit>> editUser(User user) async {
    var dataBucket = getData(["user"]);
    return await dataBucket.fold(
      (l) async => await l.doc("${user.id}").set(user.toJson()).then(
            (value) => right(unit),
            onError: () => left(NetworkError()),
          ),
      (r) => left(UnexpectedBucketHandleError()),
    );
  }

  @override
  Future<Either<Error, List<User>>> getAllUser() async {
    var dataBucket = getData(["user"]);
    return await dataBucket.fold(
      (l) async => await l.get().then(
            (value) =>
                right(value.docs.map((e) => User.fromJson(e.data())).toList()),
            onError: () => left(NetworkError()),
          ),
      (r) => left(UnexpectedBucketHandleError()),
    );
  }

  @override
  Stream<List<User>> get userStream {
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
