import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:htlib/src/db/book_db.dart';
import 'package:htlib/src/db/borrow_history_db.dart';
import 'package:htlib/src/db/config_db.dart';
import 'package:htlib/src/db/user_db.dart';
import 'package:injectable/injectable.dart';

@Singleton(signalsReady: true)
class HtlibDb {
  BookDb book = BookDb();
  BorrowingHistoryDb borrowingHistory = BorrowingHistoryDb();
  UserDb user = UserDb();
  ConfigDb config = ConfigDb();

  Future<void> init() async {
    await book.init();
    await borrowingHistory.init();
    await user.init();
    await config.init();
  }

  @factoryMethod
  static Future<HtlibDb> getDb() async {
    await Hive.initFlutter();
    HtlibDb htlibDb = HtlibDb();
    await htlibDb.init();
    return htlibDb;
  }
}
