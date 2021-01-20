import 'package:get/get.dart';

import 'package:htlib/app/modules/book_info/controllers/book_info_controller.dart';

class BookInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookInfoController>(
      () => BookInfoController(),
    );
  }
}
