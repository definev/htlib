import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:htlib/src/db/book_db.dart';
import 'package:htlib/src/db/renting_history_db.dart';
import 'package:htlib/src/db/config_db.dart';
import 'package:htlib/src/db/user_db.dart';
import 'package:injectable/injectable.dart';

@Singleton(signalsReady: true)
class HtlibDb {
  BookDb book = BookDb();
  RentingHistoryDb rentingHistory = RentingHistoryDb();
  UserDb user = UserDb();
  ConfigDb config = ConfigDb();

  Future<void> init() async {
    await book.init();
    await rentingHistory.init();
    await user.init();
    await config.init();
  }

  @factoryMethod
  static Future<HtlibDb> getDb() async {
    if (GetPlatform.isWindows) await Hive.init("D:\\htlib");
    if (GetPlatform.isMobile) await Hive.initFlutter();
    HtlibDb htlibDb = HtlibDb();
    await htlibDb.init();
    return htlibDb;
  }
}
