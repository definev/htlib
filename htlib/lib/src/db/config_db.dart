import 'package:htlib/src/db/core_db.dart';

class ConfigDb extends CoreDb {
  ConfigDb() : super("ConfigDb");

  void setDrawerSize(double width) => write("drawerSize", width);
  double get drawerSize => read("drawerSize") ?? 300;

  void setListViewSize(double width) => write("listViewSize", width);
  double get listViewSize => read("listViewSize") ?? 400;
}
