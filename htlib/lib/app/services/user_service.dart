import 'dart:developer';

import 'package:diacritic/diacritic.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:htlib/_internal/utils/error_utils.dart';
import 'package:htlib/app/data/user.dart';
import 'package:htlib/app/db/htlib_db.dart';
import 'package:htlib/app/repositories/htlib_repos.dart';

class UserService {
  List<User> _list = [];
  List<User> get list => _list ?? [];

  Future<void> init() async {
    if (GetPlatform.isWindows) {
      _list = HtlibDb.user.getList();
    } else {
      await ErrorUtils.catchNetworkError(onConnected: () async {
        var data = await HtlibRepos.user.getAllUser();
        _list = data.fold(
          (l) {
            log("USER SERVICE: ${l.toString()}");
            return _list;
          },
          (r) => r,
        );

        HtlibRepos.user.userStream.listen((newList) => _list = newList);
      }, onError: () {
        _list = HtlibDb.user.getList();
      });
    }
  }

  bool _compare(String e1, String e2) {
    e1 = removeDiacritics(e1.toLowerCase());
    e2 = removeDiacritics(e2.toLowerCase());
    if (e2.contains(e1)) return true;
    return false;
  }

  List<User> searchUser(String query) {
    List<User> _res = _list.where((user) {
      if (query.trim() == "") return false;
      if (_compare(query, user.name)) return true;
      if (_compare(query, user.currentClass)) return true;
      if (_compare(query, user.phone)) return true;
      return false;
    }).toList();

    return _res;
  }

  List<User> getBorrowedUserByISBN(String isbn) {
    List<User> _res =
        _list.where((user) => user.borrowingBookList.contains(isbn)).toList();
    return _res;
  }
}
