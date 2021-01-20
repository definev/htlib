import 'package:get/get.dart';
import 'package:htlib/app/modules/book_info/bindings/book_info_binding.dart';

import 'package:htlib/app/modules/book_management/controllers/book_management_controller.dart';
import 'package:htlib/app/modules/dashboard/bindings/dashboard_binding.dart';

class BookManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookManagementController>(
      () => BookManagementController(),
    );
    DashboardBinding().dependencies();
    BookInfoBinding().dependencies();
  }
}
