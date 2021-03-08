import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_list_tile.dart';

class ShortcutUserRentingHistoryPage extends StatefulWidget {
  final User user;

  const ShortcutUserRentingHistoryPage(this.user, {Key key}) : super(key: key);

  @override
  State<ShortcutUserRentingHistoryPage> createState() =>
      _ShortcuUsertRentingHistoryPageState();
}

class _ShortcuUsertRentingHistoryPageState
    extends State<ShortcutUserRentingHistoryPage> {
  List<RentingHistory> rentingHistoryList = [];

  @override
  void initState() {
    super.initState();
    rentingHistoryList = Get.find<RentingHistoryService>()
        .getListDataByListId(widget.user.rentingHistoryList);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rentingHistoryList.length,
      itemBuilder: (context, index) =>
          RentingHistoryListTile(rentingHistoryList[index]),
    );
  }
}
