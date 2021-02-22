import 'package:htlib/src/db/core_db.dart';

class ConfigDb extends CoreDb {
  ConfigDb() : super("ConfigDb");

  int get warningDay => read("warningDay") ?? 3;
  void setWarningDay(int day) => write("warningDay", day);
}
