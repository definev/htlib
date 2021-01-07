import 'package:htlib_admin/domain/core/value_failures/value_failure.dart';

class InvalidPasswordFailure extends ValueFailure<String> {
  InvalidPasswordFailure._(String value) : super(value);

  static haveAtLeast8Character() =>
      InvalidPasswordFailure._("Mật khẩu cần ít nhất 8 kí tự.");
  static tooWeak() => InvalidPasswordFailure._("Mật khẩu không đủ mạnh.");

  static List<String> weakPasswordList = [
    "12345678",
    "123456789",
    "11111111",
    "88888888",
    "00000000",
    "99999999",
  ];
}
