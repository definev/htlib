import 'dart:developer';

import 'package:diacritic/diacritic.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get_it/get_it.dart';
import 'package:htlib/_internal/utils/error_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:injectable/injectable.dart';

GetIt getIt = GetIt.instance;

@Singleton(dependsOn: [HtlibDb])
class UserService {
  List<User> _list = [];
  List<User> get list => _list ?? [];

  @factoryMethod
  static Future<UserService> getUserService() async {
    UserService userService = UserService();
    await userService.init();
    return userService;
  }

  Future<void> init() async {
    if (GetPlatform.isWindows) {
      _list = getIt<HtlibDb>().user.getList();
    } else {
      await ErrorUtils.catchNetworkError(onConnected: () async {
        var data = await getIt<HtlibApi>().user.getList();
        _list = data.fold(
          (l) {
            log("USER SERVICE: ${l.toString()}");
            return _list;
          },
          (r) => r,
        );

        getIt<HtlibApi>().user.subscribe().listen((newList) => _list = newList);
      }, onError: () {
        _list = getIt<HtlibDb>().user.getList();
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
