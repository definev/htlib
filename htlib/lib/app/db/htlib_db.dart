import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:htlib/app/db/book_db.dart';
import 'package:htlib/app/db/user_db.dart';

class HtlibDb {
  static BookDb book = BookDb();
  static UserDb user = UserDb();

  static Future<void> init() async {
    await Hive.initFlutter();
    await book.init();
    await user.init();
  }
}
