import 'dart:developer';

import 'package:get/get.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/data/borrowing_history.dart';
import 'package:htlib/app/data/user.dart';
import 'package:htlib/app/services/book_service.dart';
import 'package:htlib/app/services/user_service.dart';

enum BookBaseAction { increase, decrease }

class AddBorrowingHistoryDialogController extends GetxController {
  var openSeach = false.obs;
  Rx<BorrowingHistory> borrowingHistory = BorrowingHistory().obs;

  List<BookBase> _bookBaseList = [];
  List<BookBase> get bookBaseList => _bookBaseList ?? [];

  List<User> _userList = [];
  List<User> get userList => _userList ?? [];

  Rx<User> user = User.empty().obs;

  void editBookBaseList(String isbn, BookBaseAction action) {
    int index = _bookBaseList.indexWhere((element) => element.isbn == isbn);
    _bookBaseList[index] = _bookBaseList[index].copyWith(
      quantity: action == BookBaseAction.increase
          ? _bookBaseList[index].quantity + 1
          : _bookBaseList[index].quantity - 1,
    );
    log(_bookBaseList[index].toRawJson());
  }

  @override
  void onInit() {
    super.onInit();
    _bookBaseList = Get.find<BookService>().list;
    _userList = Get.find<UserService>().list;
  }
}
