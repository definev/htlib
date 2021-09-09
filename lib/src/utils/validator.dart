import 'package:htlib/src/utils/regexp_pattern.dart';

String? emptyValidator(String? text) {
  if (text == null) return null;
  if (text.isEmpty) {
    return 'Ô này không được bỏ trống.';
  }
  return null;
}

String? phoneValidator(String? text) {
  if (text == null) return null;
  text = text.replaceAll(' ', '');
  bool acceptedPhone = RegExp(RegexPattern.phone.toString()).hasMatch(text);
  if (acceptedPhone == false) {
    return 'Số điện thoại không hợp lệ. Hãy nhập lại';
  }
  return null;
}

String? numberValidator(String? text) {
  if (text == null) return null;

  bool acceptedPhone = RegExp(RegexPattern.numericOnly.toString()).hasMatch(text);
  if (acceptedPhone == false) {
    return 'Ô này chỉ chấp nhận số. Hãy nhập lại';
  }
  return null;
}

String? emailValidator(String? text) {
  if (text == null) return null;

  bool acceptedPhone = RegExp(RegexPattern.email.toString()).hasMatch(text) ||
      RegExp(RegexPattern.numericOnly.toString()).hasMatch(text);
  if (acceptedPhone == false) {
    return 'Email hoặc số điện thoại không hợp lệ. Hãy nhập lại';
  }
  return null;
}

String? passwordValidator(String? text) {
  if (text == null) return null;

  if (text.isEmpty) return 'Ô này không được bỏ trống';

  bool acceptedPhone = RegExp(RegexPattern.passport.toString()).hasMatch(text);
  if (acceptedPhone == false) {
    return 'Mật khẩu chưa đủ mạnh. Mật khẩu cần ít nhất 8 kí tự.';
  }
  return null;
}
