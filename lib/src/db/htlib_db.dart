import 'package:htlib/src/db/admin_user_db.dart';
import 'package:htlib/src/db/diagram_db.dart';
import 'package:htlib/src/model/hive_id.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:htlib/src/db/book_db.dart';
import 'package:htlib/src/db/renting_history_db.dart';
import 'package:htlib/src/db/config_db.dart';
import 'package:htlib/src/db/user_db.dart';

class HtlibDb {
  AdminUserDb admin = AdminUserDb();
  BookDb book = BookDb();
  RentingHistoryDb rentingHistory = RentingHistoryDb();
  UserDb user = UserDb();
  ConfigDb config = ConfigDb();
  DiagramDb diagram = DiagramDb();

  Future<void> init() async {
    if (kIsWeb) {
      await initWeb();
    } else if (Platform.isAndroid || Platform.isIOS) {
      await initMobile();
    } else {
      await initDesktop();
    }
  }

  Future<void> initWeb() async {
    await admin.init(disable: true);
    await book.init(disable: true);
    await rentingHistory.init(disable: true);
    await user.init(disable: true);
    await diagram.init(disable: true);
    await config.init();
  }

  Future<void> initMobile() async {
    await admin.init();
    await book.init();
    await rentingHistory.init();
    await user.init();
    await diagram.init();
    await config.init();
  }

  Future<void> initDesktop() async {
    await admin.init();
    await book.init();
    await rentingHistory.init();
    await user.init();
    await diagram.init();
    await config.init();
  }

  static Future<HtlibDb> getDb() async {
    await Hive.initFlutter("htlib");
    HiveId.registerAdapters();
    HtlibDb htlibDb = HtlibDb();

    await htlibDb.init();
    return htlibDb;
  }
}
