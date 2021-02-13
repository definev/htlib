import 'package:dartz/dartz.dart';
import 'package:htlib/src/model/user.dart';

abstract class UserApi {
  Future<Either<Error, Unit>> add(User user);

  Future<Either<Error, Unit>> edit(User user);

  Future<Either<Error, Unit>> delete(User user);

  Future<Either<Error, List<User>>> getList();

  Stream<List<User>> subscribe();
}
