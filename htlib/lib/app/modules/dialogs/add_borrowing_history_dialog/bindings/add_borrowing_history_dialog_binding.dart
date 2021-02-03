import 'package:get/get.dart';

import 'package:htlib/app/modules/dialogs/add_borrowing_history_dialog/controllers/add_borrowing_history_dialog_controller.dart';

class AddBorrowingHistoryDialogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddBorrowingHistoryDialogController>(
      () => AddBorrowingHistoryDialogController(),
    );
  }
}
