import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:htlib/app/db/htlib_db.dart';
import 'package:htlib/themes.dart';
import 'package:window_size/window_size.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!GetPlatform.isWeb) {
    setWindowTitle('App title');
    setWindowMinSize(Size(454.0, 700.0));
    setWindowMaxSize(Size.infinite);
  }
  Get.put<Rx<AppTheme>>(AppTheme.fromType(ThemeType.BlueHT).obs);
  await HtlibDb.init();

  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      theme: Get.find<Rx<AppTheme>>().value.themeData,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
