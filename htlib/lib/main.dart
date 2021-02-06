import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'package:get/get.dart';
import 'package:htlib/app/db/htlib_db.dart';
import 'package:htlib/app/services/book_service.dart';
import 'package:htlib/app/services/user_service.dart';
import 'package:htlib/themes.dart';
import 'package:window_size/window_size.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!GetPlatform.isWeb && GetPlatform.isDesktop) {
    setWindowTitle('App title');
    setWindowMinSize(Size(454.0, 700.0));
    setWindowMaxSize(Size.infinite);
  }
  Get.put<Rx<AppTheme>>(AppTheme.fromType(ThemeType.BlueHT).obs);

  await HtlibDb.init();

  BookService bookService = BookService();
  UserService userService = UserService();

  await bookService.init();
  await userService.init();

  Get.put<BookService>(bookService);
  Get.put<UserService>(userService);

  runApp(
    Portal(
      child: GetMaterialApp(
        title: "Application",
        debugShowCheckedModeBanner: false,
        theme: Get.find<Rx<AppTheme>>().value.themeData,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );
}
