import 'package:dartz/dartz.dart';
import 'package:htlib/app/data/user.dart';

mixin IUserRepo {
  Future<Either<Error, Unit>> addUser(User user);

  Future<Either<Error, Unit>> editUser(User user);

  Future<Either<Error, List<User>>> getAllUser();

  Stream<List<User>> get userStream;
}
