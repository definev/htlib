import 'package:diacritic/diacritic.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/src/model/renting_history.dart';

import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/services/state_management/core/cubit_list/cubit/list_cubit.dart';

class UserService implements CRUDService<User> {
  HtlibApi api = Get.find<HtlibApi>();
  HtlibDb db = Get.find<HtlibDb>();
  BookService bookService = Get.find();
  RentingHistoryService rentingHistoryService = Get.find();

  void _initService() {
    if (bookService == null || rentingHistoryService == null) {
      bookService = Get.find();
      rentingHistoryService = Get.find();
    }
  }

  static Future<UserService> getService() async {
    UserService userService = UserService();
    await userService.init();
    return userService;
  }

  ListCubit<User> userListCubit;

  Future<void> init() async {
    userListCubit = ListCubit<User>();
    List<User> _list = [];

    if (kIsWeb) {
      _list = await api.user.getList();
    } else if (GetPlatform.isWindows) {
      _list = db.user.getList();
    } else {
      try {
        _list = await api.user.getList();
        db.user.addList(_list, override: true);
      } catch (_) {
        _list = db.user.getList();
      }
    }

    // _list.add(User.userA());
    // _list.add(User.userB());
    // _list.add(User.userA());
    // _list.add(User.userB());
    // _list.add(User.userA());
    // _list.add(User.userB());
    // _list.add(User.userA());
    // _list.add(User.userB());

    userListCubit.addList(_list);
    // addList(_list);
  }

  bool _compare(String e1, String e2) {
    e1 = removeDiacritics(e1.toLowerCase());
    e2 = removeDiacritics(e2.toLowerCase());
    if (e2.contains(e1)) return true;
    return false;
  }

  List<User> search(String query) {
    List<User> _res = getList().where((user) {
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
        getList().where((user) => user.bookMap.containsKey(isbn)).toList();
    return _res;
  }

  Future<String> uploadImage(ImageFile image, User user) async =>
      await api.user.uploadImage(image, user);

  Future<void> removeImage(String url) => api.user.removeImage(url);

  void add(User user) {
    userListCubit.add(user);
    update(user, CRUDActionType.add);
  }

  void edit(User user) {
    userListCubit.edit(user);
    update(user, CRUDActionType.edit);
  }

  void editFromRentingHistoryReturned(RentingHistory rentingHistory) {
    User user = getDataById(rentingHistory.borrowBy);
    Map<String, int> userBookMap = user.bookMap;
    userBookMap.removeWhere((_, value) => value == null);

    rentingHistory.bookMap.forEach((key, value) {
      if (userBookMap[key] != null) {
        userBookMap[key] -= value;
        if (userBookMap[key] <= 0) {
          userBookMap[key] = null;
          userBookMap.remove(key);
        }
      }
    });

    user = user.copyWith(bookMap: userBookMap);
    edit(user);
  }

  Future<void> addAsync(ImageFile image, User user) async {
    var url = await uploadImage(image, user);
    user = user.copyWith(imageUrl: url);
    add(user);
  }

  void addList(List<User> addList) {
    userListCubit.addList(addList);
    update(addList, CRUDActionType.addList);
  }

  void remove(User user) {
    userListCubit.remove(user);
    update(user, CRUDActionType.remove);
  }

  Future<void> removeAsync(User user) async {
    _initService();
    await removeImage(user.imageUrl);
    bookService.editFromBookMap(user.bookMap);
    user.rentingHistoryList.forEach((id) =>
        rentingHistoryService.remove(rentingHistoryService.getDataById(id)));

    remove(user);
  }

  @override
  Future<void> update(dynamic data, CRUDActionType actionType,
      {bool isMock = false}) async {
    if (actionType == CRUDActionType.add) {
      db.user.add(data);
      await api.user.add(data);
    } else if (actionType == CRUDActionType.addList) {
      db.user.addList(data);
      await api.user.addList(data);
    } else if (actionType == CRUDActionType.remove) {
      db.user.remove(data);
      await api.user.remove(data);
    } else if (actionType == CRUDActionType.edit) {
      db.user.edit(data);
      await api.user.edit(data);
    }
  }

  @override
  User getDataById(String id) {
    User res = getList().firstWhere((data) => data.id == id);
    return res;
  }

  @override
  List<User> getListDataByListId(List<String> idList) {
    List<User> data = [];
    getList().forEach((e) {
      if (idList.contains(e.id)) data.add(e);
    });
    return data;
  }

  @override
  List<User> getList() => userListCubit.list ?? [];
}
