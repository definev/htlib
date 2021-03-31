import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_list_tile.dart';

class ShortcutBookRentingHistoryPage extends StatelessWidget {
  final Book book;

  const ShortcutBookRentingHistoryPage(this.book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<RentingHistory> rentingHistoryList =
        Get.find<RentingHistoryService>().getListDataByISBN(book.isbn);
    if (rentingHistoryList.isEmpty) {
      return Center(
        child: Text(
          "Chưa có lịch sử mượn",
          style: Theme.of(context).textTheme.headline5,
        ),
      );
    }

    var userService = Get.find<UserService>();

    return ListView.builder(
      itemCount: rentingHistoryList.length,
      itemBuilder: (context, index) => RentingHistoryListTile(
        rentingHistoryList[index],
        userService: userService,
        enableEdited: false,
      ),
    );
  }
}
