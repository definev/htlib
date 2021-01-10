import 'dart:developer';

import "package:htlib_admin/_internal/universal_file/universal_file.dart";
import 'package:intl/intl.dart';

class Log {
  static bool writeToDisk = true;
  static UniversalFile _printFile;
  static UniversalFile _errorFile;

  static Future<void> init() async {
    if (_printFile != null && _errorFile != null) return;
    _printFile = UniversalFile("editor-log.txt");
    _errorFile = UniversalFile("error-log.txt");
  }

  static String _formatLine(String value, bool writeTimestamp) {
    String date = writeTimestamp
        ? "${DateFormat("EEE MMM d @ H:m:s").format(DateTime.now())}: "
        : null;
    return "${date ?? ""}$value \n";
  }

  static void pHeader(String value) {
    String pattern = "";
    for (var i = 0; i < value.length; i++) {
      pattern += "-";
    }

    print("$pattern", false);
    print("[$value]", true);
    print("$pattern", false);
  }

  static void pFooter(String value, {bool err = false}) {
    value += err ? " Failed" : " Success";
    String pattern = "";
    for (var i = 0; i < value.length; i++) {
      pattern += "#";
    }

    print("$pattern", false);
    print("$value", true);
    print("$pattern", false);
  }

  static void print(String value, [bool writeTimestamp = true]) {
    init().then((_) {
      log(value);
      if (writeToDisk) {
        _printFile?.write(_formatLine(value, writeTimestamp), true);
      }
    });
  }

  static void panic(String err,
      {StackTrace stack, bool writeTimestamp = true}) {
    init().then((_) {
      log(err, name: "ERROR");
      if (writeToDisk) {
        _errorFile?.write(
          _formatLine("[ERROR]: $err\n${stack?.toString()}", writeTimestamp),
          true,
        );
      }
    });
  }
}
