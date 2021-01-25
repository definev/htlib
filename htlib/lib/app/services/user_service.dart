import 'dart:developer';

import 'package:htlib/app/data/user.dart';
import 'package:htlib/app/repositories/htlib_repos.dart';

class UserService {
  List<User> _list = [];

  Future<void> init() async {
    ;
    var data = await HtlibRepos.user.getAllUser();
    _list = data.fold(
      (l) {
        log("USER SERVICE: ${l.toString()}");
        return _list;
      },
      (r) => r,
    );

    HtlibRepos.user.userStream.listen((newList) => _list = newList);
  }

  List<User> getBorrowedUserByISBN(String isbn) {
    List<User> _res =
        _list.where((user) => user.borrowingBookList.contains(isbn)).toList();
    return _res;
  }
}
