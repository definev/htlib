import 'package:get/get.dart';

import 'package:htlib/app/modules/book_info/bindings/book_info_binding.dart';
import 'package:htlib/app/modules/book_info/views/book_info_view.dart';
import 'package:htlib/app/modules/book_management/bindings/book_management_binding.dart';
import 'package:htlib/app/modules/book_management/views/book_management_view.dart';
import 'package:htlib/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:htlib/app/modules/dashboard/views/dashboard_view.dart';
import 'package:htlib/app/modules/home/bindings/home_binding.dart';
import 'package:htlib/app/modules/home/views/home_view.dart';
import 'package:htlib/app/modules/user_management/bindings/user_management_binding.dart';
import 'package:htlib/app/modules/user_management/views/user_management_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_INFO,
      page: () => BookInfoView(),
      binding: BookInfoBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_MANAGEMENT,
      page: () => BookManagementView(),
      binding: BookManagementBinding(),
    ),
    GetPage(
      name: _Paths.USER_MANAGEMENT,
      page: () => UserManagementView(),
      binding: UserManagementBinding(),
    ),
  ];
}
