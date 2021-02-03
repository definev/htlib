import 'package:get/get.dart';

import 'package:htlib/app/modules/dialogs/add_book_base_dialog/controllers/add_book_base_dialog_controller.dart';

class AddBookBaseDialogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddBookBaseDialogController>(
      () => AddBookBaseDialogController(),
    );
  }
}
