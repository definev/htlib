import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/view/book_management/components/book_list_tile.dart';

class ShortcutUserBookPage extends StatelessWidget {
  final User user;

  const ShortcutUserBookPage(this.user, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Book> bookList =
        Get.find<BookService>().getListDataByMap(user.bookMap);
    if (bookList.isEmpty) {
      return Center(
        child: Text(
          "Không mượn sách nào",
          style: Theme.of(context).textTheme.headline5,
        ),
      );
    }

    return ListView.builder(
      itemCount: bookList.length,
      itemBuilder: (context, index) =>
          BookListTile(bookList[index]),
    );
  }
}
