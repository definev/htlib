import 'package:dartz/dartz.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:htlib_admin/domain/auth/value_failures/invalid_email_failure.dart';
import 'package:htlib_admin/domain/auth/value_failures/invalid_password_failure.dart';
import 'package:htlib_admin/domain/core/value_failures/value_failure.dart';

Either<ValueFailure<String>, String> validateEmailAddress(String value) {
  value = value.trim();
  if (GetUtils.isEmail(value)) {
    return right(value);
  }
  return left(InvalidEmailFailure.wrongFormat());
}

Either<ValueFailure<String>, String> validatePassword(String value) {
  value = value.trim();
  if (value.length < 8) {
    return left(InvalidPasswordFailure.haveAtLeast8Character());
  } else if (InvalidPasswordFailure.weakPasswordList.contains(value)) {
    return left(InvalidPasswordFailure.tooWeak());
  }

  return right(value);
}
