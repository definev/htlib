import 'package:htlib/src/db/core_db.dart';

class ConfigDb extends CoreDb {
  ConfigDb() : super("ConfigDb");

  int get warningDay => read("warningDay") ?? 3;
  void setWarningDay(int day) => write("warningDay", day);

  int get theme => read("theme") ?? 0;
  void setTheme(int theme) => write("theme", theme);
  Stream<int> themeSubscribe() => box.watch().map((event) => event.value);

  int get themeMode => read("themeMode") ?? 0;
  void setThemeMode(int themeMode) => write("themeMode", themeMode);
}
