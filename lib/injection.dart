import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/services/single_user_service.dart';
import 'package:htlib/src/services/user_service.dart';

import 'mode/mode.dart';

Future<void> configureDependencies({String? mode}) async {
  MODE = mode;
  await init(mode);
}

Future<void> cleanCacheService() async {
  await Get.delete<BookService>(force: true);
  await Get.delete<RentingHistoryService>(force: true);
  await Get.delete<AdminService>(force: true);
  await Get.delete<UserService>(force: true);
}

Future<void> putService() async {
  await Get.putAsync<BookService>(
    () async => await BookService.getService(),
    permanent: true,
  );
  await Get.putAsync<RentingHistoryService>(
    () async => await RentingHistoryService.getService(),
    permanent: true,
  );
  if (await Get.find<HtlibApi>().admin.isLibrarian() || await Get.find<HtlibApi>().admin.isMornitor()) {
    await Get.putAsync(
      () async => await AdminService.getService(),
      permanent: true,
    );
    await Get.putAsync<UserService>(
      () async => await UserService.getService(),
      permanent: true,
    );
  } else {
    if (FirebaseAuth.instance.currentUser != null)
      await Get.putAsync<SingleUserService>(() async => await SingleUserService.getService());
  }
}

Future<void> init(String? mode) async {
  Get.put<HtlibApi>(HtlibApi());
  final db = await HtlibDb.getDb();
  Get.put<HtlibDb>(db, permanent: true);
  if (mode == "Prod" && (GetPlatform.isDesktop || FirebaseAuth.instance.currentUser != null)) {
    await putService();
  }
}
