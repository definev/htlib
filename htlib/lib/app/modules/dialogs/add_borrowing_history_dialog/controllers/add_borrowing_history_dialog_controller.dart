import 'package:get/get.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/data/borrowing_history.dart';
import 'package:htlib/app/modules/dashboard/controllers/dashboard_controller.dart';

class AddBorrowingHistoryDialogController extends GetxController {
  var openSeach = false.obs;
  List<BookBase> _bookBaseList = [];
  Rx<BorrowingHistory> borrowingHistory = BorrowingHistory().obs;

  List<BookBase> get bookBaseList => _bookBaseList ?? [];
  void editBookBaseList(BookBase bookBase) {
    int index =
        _bookBaseList.indexWhere((element) => element.isbn == bookBase.isbn);
    _bookBaseList[index] = bookBase;
  }

  @override
  void onInit() {
    super.onInit();
    _bookBaseList = Get.find<DashboardController>().bookBaseList;
  }
}
