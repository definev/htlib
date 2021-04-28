import 'package:universal_io/io.dart';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:htlib/src/db/book_db.dart';
import 'package:htlib/src/db/renting_history_db.dart';
import 'package:htlib/src/db/config_db.dart';
import 'package:htlib/src/db/user_db.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/model/user.dart';

class HtlibDb {
  BookDb book = BookDb();
  RentingHistoryDb rentingHistory = RentingHistoryDb();
  UserDb user = UserDb();
  ConfigDb config = ConfigDb();

  Future<void> init() async {
    if (kIsWeb) {
      await initWeb();
    } else if (Platform.isAndroid) {
      await initMobile();
    } else {
      await initDesktop();
    }
  }

  Future<void> initWeb() async {
    await book.init(disable: true);
    await rentingHistory.init(disable: true);
    await user.init(disable: true);
    await config.init();
  }

  Future<void> initMobile() async {
    await book.init();
    await rentingHistory.init();
    await user.init();
    await config.init();
  }

  Future<void> initDesktop() async {
    await book.init();
    await rentingHistory.init();
    await user.init();
    await config.init();
  }

  static Future<HtlibDb> getDb() async {
    await Hive.initFlutter("htlib");
    if (!Hive.isAdapterRegistered(BookAdapter().typeId))
      Hive.registerAdapter(BookAdapter());
    if (!Hive.isAdapterRegistered(RentingHistoryAdapter().typeId))
      Hive.registerAdapter(RentingHistoryAdapter());
    if (!Hive.isAdapterRegistered(UserAdapter().typeId))
      Hive.registerAdapter(UserAdapter());

    HtlibDb htlibDb = HtlibDb();

    await htlibDb.init();
    return htlibDb;
  }
}
