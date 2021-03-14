import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_list_tile.dart';

class ShortcutUserRentingHistoryPage extends StatelessWidget {
  final User user;

  const ShortcutUserRentingHistoryPage(this.user, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<RentingHistory> rentingHistoryList = Get.find<RentingHistoryService>()
        .getListDataByListId(user.rentingHistoryList);
    UserService userService = Get.find();
    if (rentingHistoryList.isEmpty) {
      return Center(
        child: Text(
          "Chưa có lịch sử mượn",
          style: Theme.of(context).textTheme.headline5,
        ),
      );
    }

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
