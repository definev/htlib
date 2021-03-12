import 'package:animations/animations.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_list_tile.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_screen.dart';

class ShortcutBookRentingHistoryPage extends StatelessWidget {
  final Book book;

  const ShortcutBookRentingHistoryPage(this.book, {Key key}) : super(key: key);

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
      itemBuilder: (context, index) => OpenContainer(
        closedBuilder: (context, onTap) =>
            RentingHistoryListTile(rentingHistoryList[index], onTap: onTap),
        closedShape: RoundedRectangleBorder(),
        closedColor: Theme.of(context).backgroundColor,
        closedElevation: 0.0,
        openBuilder: (context, onTap) => RentingHistoryScreen(
          rentingHistory: rentingHistoryList[index],
          onTap: onTap,
          userService: userService,
          stateCode:
              RentingHistoryStateCode.values[rentingHistoryList[index].state],
        ),
      ),
    );
  }
}
