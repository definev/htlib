import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/view/user_management/components/user_list_tile.dart';

class ShortcutBookUserPage extends StatefulWidget {
  final Book book;

  const ShortcutBookUserPage(this.book, {Key key}) : super(key: key);

  @override
  State<ShortcutBookUserPage> createState() => _ShortcutBookUserPageState();
}

class _ShortcutBookUserPageState extends State<ShortcutBookUserPage> {
  List<User> userList = [];

  @override
  void initState() {
    super.initState();
    userList = Get.find<UserService>().getBorrowedUserByISBN(widget.book.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) => UserListTile(userList[index]),
    );
  }
}
