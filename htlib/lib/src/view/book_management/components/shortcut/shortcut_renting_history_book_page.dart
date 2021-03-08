import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/view/book_management/components/book_list_tile.dart';

class ShortcutRentingHistoryBookPage extends StatefulWidget {
  final RentingHistory rentingHistory;

  const ShortcutRentingHistoryBookPage(this.rentingHistory, {Key key})
      : super(key: key);

  @override
  State<ShortcutRentingHistoryBookPage> createState() =>
      _ShortcutRentingHistoryBookPageState();
}

class _ShortcutRentingHistoryBookPageState
    extends State<ShortcutRentingHistoryBookPage> {
  List<Book> bookList = [];

  @override
  void initState() {
    super.initState();
    bookList = Get.find<BookService>()
        .getListDataByListId(widget.rentingHistory.bookList);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookList.length,
      itemBuilder: (context, index) => BookListTile(bookList[index]),
    );
  }
}
