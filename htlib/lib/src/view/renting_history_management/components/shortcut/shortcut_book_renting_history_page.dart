import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_list_tile.dart';

class ShortcutBookRentingHistoryPage extends StatefulWidget {
  final Book book;

  const ShortcutBookRentingHistoryPage(this.book, {Key key}) : super(key: key);

  @override
  State<ShortcutBookRentingHistoryPage> createState() =>
      _ShortcutBookRentingHistoryPageState();
}

class _ShortcutBookRentingHistoryPageState
    extends State<ShortcutBookRentingHistoryPage> {
  List<RentingHistory> rentingHistoryList = [];

  @override
  void initState() {
    super.initState();
    rentingHistoryList =
        Get.find<RentingHistoryService>().getListDataByISBN(widget.book.isbn);
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
