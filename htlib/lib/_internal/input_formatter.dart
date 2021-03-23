import 'package:flutter/services.dart';
import 'package:htlib/_internal/utils/string_utils.dart';

class PhoneFormatter extends TextInputFormatter {
  TextEditingValue phoneFormat(TextEditingValue value) {
    var text = StringUtils.phoneFormat(value.text.replaceAll("-", ""));
    return value.copyWith(text: text);
  }

  // 0929623960

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 10) return phoneFormat(oldValue);
    return phoneFormat(newValue);
  }
}

class MoneyFormatter extends TextInputFormatter {
  TextEditingValue moneyFormat(TextEditingValue value) {
    String raw = value.text;
    raw = raw.replaceAll(",", "");
    RegExp regExp = RegExp(r'^[1-9]\d*$');
    String price = regExp.firstMatch(raw)?.group(0);
    if (price == "" || price == null)
      return value.copyWith(
          text: "0", selection: TextSelection.collapsed(offset: 1));
    var text = StringUtils.moneyFormat(int.parse(price));
    return value.copyWith(text: text);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 10) return moneyFormat(oldValue);
    return moneyFormat(newValue);
  }
}
