import 'package:htlib_admin/domain/auth/validator.dart';
import 'package:htlib_admin/domain/core/value_failures/value_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib_admin/domain/core/value_objects/value_object.dart';

class Password extends ValueObject<String> {
  factory Password(String value) {
    assert(value != null);

    return Password._(validatePassword(value));
  }

  Password._(this.value);

  @override
  Either<ValueFailure<String>, String> value;
}
