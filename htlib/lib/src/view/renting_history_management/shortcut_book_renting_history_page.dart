import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/view/book_management/components/book_list_tile.dart';

class ShortcutUserBookPage extends StatefulWidget {
  final User user;

  const ShortcutUserBookPage({Key key, this.user}) : super(key: key);

  @override
  State<ShortcutUserBookPage> createState() => _ShortcutUserBookPageState();
}

class _ShortcutUserBookPageState extends State<ShortcutUserBookPage> {
  List<Book> bookList = [];

  @override
  void initState() {
    super.initState();
    bookList =
        Get.find<BookService>().getListDataByListId(widget.user.bookList);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookList.length,
      itemBuilder: (context, index) => BookListTile(bookList[index]),
    );
  }
}
