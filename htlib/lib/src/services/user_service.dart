import 'package:diacritic/diacritic.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:htlib/_internal/utils/file_utils.dart';

import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';

class UserService implements CRUDService<User> {
  HtlibApi api = Get.find<HtlibApi>();
  HtlibDb db = Get.find<HtlibDb>();

  static Future<UserService> getService() async {
    UserService userService = UserService();
    await userService.init();
    return userService;
  }

  ListBloc<User> userListBloc;

  Future<void> init() async {
    userListBloc = ListBloc<User>();
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

    _list.add(User.empty());

    userListBloc.add(ListEvent.addList(_list));
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
        getList().where((user) => user.bookList.contains(isbn)).toList();
    return _res;
  }

  Future<String> uploadImage(ImageFile image, User user) =>
      api.user.uploadImage(image, user);

  Future<String> removeImage(String url) => api.user.removeImage(url);

  void add(User user) {
    userListBloc.add(ListEvent.add(user));
    update(user, CRUDActionType.add);
  }

  void edit(User user) {
    userListBloc.add(ListEvent.add(user));
    update(user, CRUDActionType.edit);
  }

  Future<void> addAsync(ImageFile image, User user) async {
    userListBloc.add(ListEvent.add(user));
    var url = await uploadImage(image, user);
    user = user.copyWith(imageUrl: url);
    await update(user, CRUDActionType.add);
  }

  void addList(List<User> addList) {
    userListBloc.add(ListEvent.addList(addList));
    update(addList, CRUDActionType.addList);
  }

  void remove(User user) {
    userListBloc.add(ListEvent.remove(user));
    update(user, CRUDActionType.remove);
  }

  Future<void> removeAsync(User user) async {
    userListBloc.add(ListEvent.remove(user));
    await removeImage(user.imageUrl);
    await update(user, CRUDActionType.remove);
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
  List<User> getList() => userListBloc.list ?? [];
}
