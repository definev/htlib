import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/model/renting_history.dart';

import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/services/state_management/list/list_cubit.dart';

class UserService implements CRUDService<User> {
  HtlibApi api = Get.find<HtlibApi>();
  HtlibDb db = Get.find<HtlibDb>();
  BookService bookService = Get.find();
  RentingHistoryService rentingHistoryService = Get.find();

  static Future<UserService> getService() async {
    UserService userService = UserService();
    await userService.init();
    return userService;
  }

  late ListCubit<User> userListCubit;

  AdminService adminService = Get.find();

  Future<void> init() async {
    userListCubit = ListCubit<User>();
    List<User> _list = [];

    if (kIsWeb) {
      if (adminService.currentUser.value.adminType == AdminType.librarian) {
        _list = await api.student.getList();
      } else {
        _list = await api.student.getClassList(adminService.currentUser.value.className!);
      }
    } else if (GetPlatform.isWindows) {
      _list = db.user.getList();
    } else {
      try {
        if (adminService.currentUser.value.adminType == AdminType.librarian) {
          _list = await api.student.getList();
        } else {
          _list = await api.student.getClassList(adminService.currentUser.value.className!);
        }
        db.user.addList(_list, override: true);
      } catch (_) {
        _list = db.user.getList();
      }
    }

    if (adminService.currentUser.value.adminType == AdminType.mornitor) {
      _list = _list.where((u) => u.className == adminService.currentUser.value.className).toList();
    }
    userListCubit.addList(_list);
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
      if (_compare(query, user.id)) return true;
      if (_compare(query, user.name)) return true;
      if (_compare(query, user.className)) return true;
      if (_compare(query, user.phone)) return true;
      return false;
    }).toList();

    return _res;
  }

  List<User> getBorrowedUserByISBN(String? isbn) {
    List<User> _res = getList().where((user) => user.bookMap.containsKey(isbn)).toList();
    return _res;
  }

  Future<String> uploadImage(ImageFile? image, User user) async => await api.student.uploadImage(image, user);

  Future<void> removeImage(String url) => api.student.removeImage(url);

  void add(User user) {
    userListCubit.add(user);
    db.user.add(user);
    api.student.add(user);
  }

  void edit(User user) {
    userListCubit.edit(user, where: (prev, curr) => prev == curr);
    db.user.edit(user);
    api.student.edit(user);
  }

  void editFromRentingHistoryReturned(RentingHistory rentingHistory) {
    User user = getDataById(rentingHistory.borrowBy);
    Map<String, int?> userBookMap = user.bookMap;

    rentingHistory.bookMap.forEach((key, value) {
      if (userBookMap[key] != null) {
        userBookMap[key] = userBookMap[key]! - value;
        if (userBookMap[key]! <= 0) {
          userBookMap[key] = null;
          userBookMap.remove(key);
        }
      }
    });

    user = user.copyWith(bookMap: userBookMap as Map<String, int>);
    edit(user);
  }

  Future<void> addAsync(ImageFile? image, User user) async {
    var url = await uploadImage(image, user);
    user = user.copyWith(imageUrl: url);
    add(user);
  }

  Future<void> createUserAccount(String phone, String password) =>
      auth.FirebaseAuth.instance.createUserWithEmailAndPassword(email: '${phone}@htlib.com', password: password);

  void addList(List<User> addList) {
    userListCubit.addList(addList);
    db.user.addList(addList);
    api.student.addList(addList);
  }

  void remove(User user) {
    userListCubit.remove(user, where: (prev, curr) => prev == curr);
    db.user.remove(user);
    api.student.remove(user);
  }

  Future<void> removeAsync(User user) async {
    removeImage(user.imageUrl!);
    bookService.editFromBookMap(user.bookMap);
    user.rentingHistoryList.forEach(
      (id) => rentingHistoryService.remove(rentingHistoryService.getDataById(id)),
    );

    remove(user);
  }

  @override
  User getDataById(String? id) {
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
  List<User> getList() => userListCubit.list;
}
