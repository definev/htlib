import 'package:dartz/dartz.dart';
import 'package:htlib_admin/domain/auth/entities/user.dart';
import 'package:htlib_admin/domain/auth/value_objects/email_address.dart';
import 'package:htlib_admin/domain/auth/value_objects/password.dart';
import 'package:htlib_admin/domain/core/value_errors/value_error.dart';

abstract class IAuthFacade {
  /// Sign up with `Email Address` and `Password`
  Future<Either<ValueError, Unit>> signUpWithEmailAddressAndPassword(
    EmailAddress emailAddress,
    Password password,
  );

  /// Sign in with `Email Address` and `Password`
  Future<Either<ValueError, User>> signInWithEmailAddressAndPassword(
    EmailAddress emailAddress,
    Password password,
  );

  Future<Either<ValueError, User>> signInWithGoogle();

  Future<Either<ValueError, User>> signInWithFacebook();

  Future<Either<ValueError, User>> signInWithGithub();
}
