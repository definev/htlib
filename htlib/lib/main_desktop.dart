import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:htlib/themes.dart';

import 'app/routes/app_pages.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  Get.put<Rx<AppTheme>>(AppTheme.fromType(ThemeType.BlueHT).obs);

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
