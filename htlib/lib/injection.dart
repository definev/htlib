import 'package:get/get.dart';

import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/borrowing_history_service.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:injectable/injectable.dart';

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async => await init();

Future<void> init() async {
  Get.put<HtlibApi>(HtlibApi());
  await Get.putAsync<HtlibDb>(() async => await HtlibDb.getDb());
  await Get.putAsync<BookService>(() async => await BookService.getService());
  await Get.putAsync<BorrowingHistoryService>(
      () async => await BorrowingHistoryService.getService());
  await Get.putAsync<UserService>(() async => await UserService.getService());
}
