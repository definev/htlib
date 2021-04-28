import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/view/user_management/components/user_list_tile.dart';

class ShortcutBookUserPage extends StatelessWidget {
  final Book book;

  const ShortcutBookUserPage(this.book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<User> userList =
        Get.find<UserService>().getBorrowedUserByISBN(book.isbn);
    if (userList.isEmpty) {
      return Center(
        child: Text(
          "Chưa ai mượn sách",
          style: Theme.of(context).textTheme.headline5,
        ),
      );
    }

    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) => UserListTile(
        userList[index],
        mode: UserListTileMode.call,
      ),
    );
  }
}
