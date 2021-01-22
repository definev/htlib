import 'package:get/get.dart';

import 'package:htlib/app/modules/user_management/controllers/user_management_controller.dart';

class UserManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManagementController>(
      () => UserManagementController(),
    );
  }
}
