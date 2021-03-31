import 'package:htlib/src/db/core/core_db.dart';

class ConfigDb extends CoreDb {
  ConfigDb() : super("ConfigDb");

  int get warningDay => read("warningDay") ?? 3;
  void setWarningDay(int day) => write("warningDay", day);

  int get theme => read("theme") ?? 0;
  void setTheme(int? theme) => write("theme", theme);
  Stream<int?> themeSubscribe() => box!.watch().map((event) => event.value);

  int get themeMode => read("themeMode") ?? 0;
  void setThemeMode(int themeMode) => write("themeMode", themeMode);

  int get buttonMode => read("buttonMode") ?? 0;
  void setButtonMode(int buttonMode) => write("buttonMode", buttonMode);
  Stream<int?> buttonModeSubscribe() =>
      box!.watch(key: "buttonMode").map((event) => event.value);
}
