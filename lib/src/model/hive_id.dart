import 'package:hive/hive.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/diagram_node.dart';
import 'package:htlib/src/model/diagram_node_mode.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/model/user.dart';

class HiveId {
  static const int book = 0;
  static const int rentingHistory = 1;
  static const int user = 2;
  static const int diagram_node = 3;
  static const int diagram_mode_mode = 4;
  static const int adminUser = 5;
  static const int adminType = 6;

  static registerAdapters() {
    if (!Hive.isAdapterRegistered(BookAdapter().typeId)) Hive.registerAdapter(BookAdapter());
    if (!Hive.isAdapterRegistered(RentingHistoryAdapter().typeId)) Hive.registerAdapter(RentingHistoryAdapter());
    if (!Hive.isAdapterRegistered(UserAdapter().typeId)) Hive.registerAdapter(UserAdapter());
    if (!Hive.isAdapterRegistered(DiagramNodeAdapter().typeId)) Hive.registerAdapter(DiagramNodeAdapter());
    if (!Hive.isAdapterRegistered(DiagramNodeModeAdapter().typeId)) Hive.registerAdapter(DiagramNodeModeAdapter());
    if (!Hive.isAdapterRegistered(AdminTypeAdapter().typeId)) Hive.registerAdapter(AdminTypeAdapter());
    if (!Hive.isAdapterRegistered(AdminUserAdapter().typeId)) Hive.registerAdapter(AdminUserAdapter());
  }
}
