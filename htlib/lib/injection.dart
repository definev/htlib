import 'package:get/get.dart';

import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/services/user_service.dart';

import 'mode/mode.dart';

Future<void> configureDependencies({String mode}) async {
  MODE = mode;
  await init();
}

Future<void> init() async {
  Get.put<HtlibApi>(HtlibApi());
  await Get.putAsync<HtlibDb>(() async => await HtlibDb.getDb());
  await Get.putAsync<BookService>(() async => await BookService.getService());
  await Get.putAsync<RentingHistoryService>(
      () async => await RentingHistoryService.getService());
  await Get.putAsync<UserService>(() async => await UserService.getService());
}
