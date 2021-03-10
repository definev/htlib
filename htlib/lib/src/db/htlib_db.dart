import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:htlib/src/db/book_db.dart';
import 'package:htlib/src/db/renting_history_db.dart';
import 'package:htlib/src/db/config_db.dart';
import 'package:htlib/src/db/user_db.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/model/user.dart';
import 'package:injectable/injectable.dart';

@Singleton(signalsReady: true)
class HtlibDb {
  BookDb book = BookDb();
  RentingHistoryDb rentingHistory = RentingHistoryDb();
  UserDb user = UserDb();
  ConfigDb config = ConfigDb();

  Future<void> init() async {
    if (kIsWeb)
      await initWeb();
    else
      await initMobile();
  }

  Future<void> initMobile() async {
    await book.init();
    await rentingHistory.init();
    await user.init();
    await config.init();
  }

  Future<void> initWeb() async {
    await book.init(disable: true);
    await rentingHistory.init(disable: true);
    await user.init(disable: true);
    await config.init();
  }

  @factoryMethod
  static Future<HtlibDb> getDb() async {
    if (GetPlatform.isWindows) {
      await Hive
        ..init("D:\\htlib")
        ..registerAdapter(BookAdapter())
        ..registerAdapter(RentingHistoryAdapter())
        ..registerAdapter(UserAdapter());
    } else {
      await Hive
        ..initFlutter()
        ..registerAdapter(BookAdapter())
        ..registerAdapter(RentingHistoryAdapter())
        ..registerAdapter(UserAdapter());
    }
    HtlibDb htlibDb = HtlibDb();

    await htlibDb.init();
    return htlibDb;
  }
}
