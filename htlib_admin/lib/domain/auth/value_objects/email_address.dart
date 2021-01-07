import 'package:htlib_admin/domain/auth/validator.dart';
import 'package:htlib_admin/domain/core/value_failures/value_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib_admin/domain/core/value_objects/value_object.dart';

class EmailAddress extends ValueObject<String> {
  factory EmailAddress(String value) {
    assert(value != null);

    return EmailAddress._(validateEmailAddress(value));
  }

  EmailAddress._(this.value);

  @override
  Either<ValueFailure<String>, String> value;
}
