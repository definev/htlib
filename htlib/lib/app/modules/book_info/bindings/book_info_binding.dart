import 'package:get/get.dart';
import 'package:htlib/app/modules/book_info/components/lending_tab/bindings/lending_tab_binding.dart';

import 'package:htlib/app/modules/book_info/controllers/book_info_controller.dart';

class BookInfoBinding extends Bindings {
  @override
  void dependencies() {
    LendingTabBinding().dependencies();
    Get.lazyPut<BookInfoController>(
      () => BookInfoController(),
    );
  }
}
