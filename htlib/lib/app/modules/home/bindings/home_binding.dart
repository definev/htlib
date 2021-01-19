import 'package:get/get.dart';
import 'package:htlib/app/modules/dashboard/bindings/dashboard_binding.dart';

import 'package:htlib/app/modules/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    DashboardBinding().dependencies();
  }
}
