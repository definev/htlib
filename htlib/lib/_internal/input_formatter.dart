import 'package:flutter/services.dart';
import 'package:htlib/_internal/utils/string_utils.dart';

class PhoneFormatter extends TextInputFormatter {
  TextEditingValue phoneFormat(TextEditingValue value) {
    var text = StringUtils.phoneFormat(value.text.replaceAll("-", ""));
    return value.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  // 0929623960

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 10) return phoneFormat(oldValue);
    return phoneFormat(newValue);
  }
}
