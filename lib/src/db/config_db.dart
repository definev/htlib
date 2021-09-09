import 'dart:convert';

import 'package:htlib/src/db/core/core_db.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseUser {
  final String? email;
  final String? password;

  FirebaseUser(this.email, this.password);

  static FirebaseUser empty() => FirebaseUser(null, null);
  bool get isNotEmpty => email != null && password != null;

  factory FirebaseUser.fromJson(Map<String, dynamic> json) => FirebaseUser(json["email"], json["password"]);
  Map<String, dynamic> toJson() => {"email": email!, "password": password!};
  String toRawJson() => jsonEncode(toJson());
}

class ConfigDb extends CoreDb<dynamic> {
  ConfigDb() : super("ConfigDb");

  int get warningDay => read("warningDay") ?? 3;
  void setWarningDay(int day) => write("warningDay", day);

  int get theme => read("theme") ?? 0;
  void setTheme(int? theme) => write("theme", theme);
  Stream<int?> themeSubscribe() {
    return MergeStream([
      box!.watch(key: "theme").map((event) => event.value),
      box!.watch(key: "themeMode").map((event) => event.value),
    ]);
  }

  int get themeMode => read("themeMode") ?? 0;
  void setThemeMode(int themeMode) => write("themeMode", themeMode);

  int get buttonMode => read("buttonMode") ?? 0;
  void setButtonMode(int buttonMode) => write("buttonMode", buttonMode);
  Stream<int?> buttonModeSubscribe() => box!.watch(key: "buttonMode").map((event) => event.value);

  void removeFirebaseUser() => delete("firebaseUser");
}
