import 'package:get/get.dart';
import 'package:htlib/app/modules/book_management/bindings/book_management_binding.dart';

import 'package:htlib/app/modules/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    BookManagementBinding().dependencies();
  }
}
