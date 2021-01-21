import 'package:get/get.dart';
import 'package:htlib/app/modules/book_info/components/lending_tab/controllers/lending_tab_controller.dart';

class LendingTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LendingTabController>(
      () => LendingTabController(),
    );
  }
}
