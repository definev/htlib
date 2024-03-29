import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/platform/platform.dart';

import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/state_management/list/list_cubit.dart';
import 'package:htlib/src/services/user_service.dart';

class RentingHistoryService implements CRUDService<RentingHistory> {
  static Future<RentingHistoryService> getService() async {
    RentingHistoryService rentingHistoryService = RentingHistoryService();
    await rentingHistoryService.init();
    return rentingHistoryService;
  }

  HtlibApi api = Get.find<HtlibApi>();
  HtlibDb db = Get.find<HtlibDb>();
  BookService? bookService;
  UserService? userService;

  late ListCubit<RentingHistory> rentingHistoryListCubit;

  void _initService() {
    if (bookService == null || userService == null) {
      bookService = Get.find<BookService>();
      userService = Get.find<UserService>();
    }
  }

  Future<void> init() async {
    rentingHistoryListCubit = ListCubit<RentingHistory>();

    List<RentingHistory> _list = [];
    if (kIsWeb) {
      _list = await api.rentingHistory.getList();
    } else if (GetPlatform.isDesktop) {
      _list = db.rentingHistory.getList();
    } else {
      try {
        _list = await api.rentingHistory.getList();
        db.rentingHistory.addList(_list, override: true);
      } catch (_) {
        _list = db.rentingHistory.getList();
      }
    }

    rentingHistoryListCubit.addList(_list);
  }

  Future<void> addAsync(
    RentingHistory rentingHistory, {
    required User user,
    required Map<String?, int> bookMap,
    List<Book>? allBookList,
  }) async {
    _initService();
    add(rentingHistory);

    Map<String, int> _userBookMap = user.bookMap;

    bookMap.forEach((key, value) {
      if (_userBookMap[key] != null)
        _userBookMap[key!] = _userBookMap[key]! + value;
      else
        _userBookMap[key!] = value;
    });

    List<String> _userRentingHistoryList = user.rentingHistoryList;
    _userRentingHistoryList.add(rentingHistory.id);

    user = user.copyWith(
      bookMap: _userBookMap,
      rentingHistoryList: _userRentingHistoryList,
    );
    userService!.edit(user);

    _userBookMap.forEach((key, value) {
      int i = allBookList!.indexWhere((e) => e.isbn == key);
      bookService!.edit(allBookList[i]);
    });
  }

  void add(RentingHistory rentingHistory) {
    // if (rentingHistory == null) return;
    rentingHistoryListCubit.add(rentingHistory);
    print("${rentingHistory.toJson()}");
    db.rentingHistory.add(rentingHistory);
    api.rentingHistory.add(rentingHistory);
  }

  void returnAsync(RentingHistory rentingHistory) async {
    _initService();
    // if (rentingHistory == null) return;
    rentingHistory = rentingHistory.copyWith(state: RentingHistoryStateCode.returned.index);
    bookService!.editFromBookMap(rentingHistory.bookMap);
    userService!.editFromRentingHistoryReturned(rentingHistory);
    edit(rentingHistory);
  }

  void edit(RentingHistory rentingHistory) {
    // if (rentingHistory == null) return;
    rentingHistoryListCubit.edit(rentingHistory, where: (prev, curr) => prev == curr);
    print("${rentingHistory.toJson()}");
    db.rentingHistory.edit(rentingHistory);
    api.rentingHistory.edit(rentingHistory);
  }

  void addList(List<RentingHistory> addList) {
    // if (addList == null) return;
    rentingHistoryListCubit.addList(addList);
    db.rentingHistory.addList(addList);
    api.rentingHistory.addList(addList);
  }

  void remove(RentingHistory rentingHistory) {
    // if (rentingHistory == null) return;
    rentingHistoryListCubit.remove(rentingHistory, where: (prev, curr) => prev == curr);
    print("${rentingHistory.toJson()}");
    db.rentingHistory.remove(rentingHistory);
    api.rentingHistory.remove(rentingHistory);
  }

  List<RentingHistory> search(String query) {
    query = query.trim().toLowerCase();

    if (query == "") return [];

    List<RentingHistory> res = getList().where((rentingHistory) {
      if (rentingHistory.id == query) return true;
      if (rentingHistory.borrowBy == query) return true;
      return false;
    }).toList();

    return res;
  }

  @override
  RentingHistory getDataById(String? id) {
    RentingHistory res = getList().firstWhere((data) => data.id == id);
    return res;
  }

  @override
  List<RentingHistory> getListDataByListId(List<String?>? idList) {
    List<RentingHistory> data = [];
    getList().forEach((e) {
      if (idList!.contains(e.id)) data.add(e);
    });
    return data;
  }

  List<RentingHistory> getListDataByISBN(String? isbn) {
    List<RentingHistory> data = [];
    getList().forEach((e) {
      if (e.bookMap.containsKey(isbn)) data.add(e);
    });
    return data;
  }

  @override
  List<RentingHistory> getList() => rentingHistoryListCubit.list;
}
