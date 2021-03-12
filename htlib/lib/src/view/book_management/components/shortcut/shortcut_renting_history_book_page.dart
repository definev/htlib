import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/view/book_management/components/book_list_tile.dart';

class ShortcutRentingHistoryBookPage extends StatelessWidget {
  final RentingHistory rentingHistory;

  const ShortcutRentingHistoryBookPage(this.rentingHistory, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Book> bookList =
        Get.find<BookService>().getListDataByMap(rentingHistory.bookMap);
    if (bookList.isEmpty) {
      return Center(
        child: Text(
          "Sách đã xóa hoặc không tồn tại",
          style: Theme.of(context).textTheme.headline5,
        ),
      );
    }

    return ListView.builder(
      itemCount: bookList.length,
      itemBuilder: (context, index) => BookListTile(bookList[index]),
    );
  }
}
