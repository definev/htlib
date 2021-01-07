import 'package:htlib_admin/domain/core/value_failures/value_failure.dart';

class InvalidEmailFailure extends ValueFailure<String> {
  InvalidEmailFailure._(String value) : super(value);

  static wrongFormat() => InvalidEmailFailure._("Email sai định dạng.");
}
