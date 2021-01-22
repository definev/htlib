import 'package:get/get.dart';
import 'package:htlib/app/modules/book_management/bindings/book_management_binding.dart';

import 'package:htlib/app/modules/home/controllers/home_controller.dart';
import 'package:htlib/app/modules/user_management/bindings/user_management_binding.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    BookManagementBinding().dependencies();
    UserManagementBinding().dependencies();
  }
}
