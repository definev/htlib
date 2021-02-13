import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:htlib/src/db/book_db.dart';
import 'package:htlib/src/db/config_db.dart';
import 'package:htlib/src/db/user_db.dart';
import 'package:injectable/injectable.dart';

@singleton
class HtlibDb {
  BookDb book = BookDb();
  UserDb user = UserDb();
  ConfigDb config = ConfigDb();

  @factoryMethod
  static Future<HtlibDb> getDb() async {
    await Hive.initFlutter();
    HtlibDb htlibDb = HtlibDb();
    await htlibDb.book.init();
    await htlibDb.user.init();
    await htlibDb.config.init();
    return htlibDb;
  }
}
