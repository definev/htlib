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
import 'package:htlib/src/services/state_management/core/cubit_list/cubit/list_cubit.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:htlib/src/services/user_service.dart';

class RentingHistoryService implements CRUDService<RentingHistory> {
  static Future<RentingHistoryService> getService() async {
    RentingHistoryService rentingHistoryService = RentingHistoryService();
    await rentingHistoryService.init();
    return rentingHistoryService;
  }

  HtlibApi api = Get.find<HtlibApi>();
  HtlibDb db = Get.find<HtlibDb>();
  BookService bookService;
  UserService userService;

  ListBloc<RentingHistory> rentingHistoryListBloc;
  ListCubit<RentingHistory> rentingHistoryListCubit;

  void _initService() {
    if (bookService == null || userService == null) {
      bookService = Get.find();
      userService = Get.find();
    }
  }

  Future<void> init() async {
    rentingHistoryListBloc = ListBloc<RentingHistory>();
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
    rentingHistoryListBloc.add(ListEvent.addList(_list));
  }

  Future<void> addAsync(
    RentingHistory rentingHistory, {
    User user,
    Map<String, int> bookMap,
    List<Book> allBookList,
  }) async {
    _initService();
    await add(rentingHistory);

    Map<String, int> _userBookMap = user.bookMap;

    bookMap.forEach((key, value) {
      if (_userBookMap[key] != null)
        _userBookMap[key] += value;
      else
        _userBookMap[key] = value;
    });

    List<String> _userRentingHistoryList = user.rentingHistoryList;
    _userRentingHistoryList.add(rentingHistory.id);

    user = user.copyWith(
      bookMap: _userBookMap,
      rentingHistoryList: _userRentingHistoryList,
    );
    userService.edit(user);

    _userBookMap.forEach((key, value) {
      int i = allBookList.indexWhere((e) => e.isbn == key);
      bookService.edit(allBookList[i]);
    });
  }

  void add(RentingHistory rentingHistory) {
    if (rentingHistory == null) return;
    rentingHistoryListCubit.add(rentingHistory);
    rentingHistoryListBloc.add(ListEvent.add(rentingHistory));
    print("${rentingHistory.toJson()}");
    update(rentingHistory, CRUDActionType.add);
  }

  void returnAsync(RentingHistory rentingHistory) async {
    _initService();
    if (rentingHistory == null) return;
    rentingHistory =
        rentingHistory.copyWith(state: RentingHistoryStateCode.returned.index);
    bookService.editFromBookMap(rentingHistory.bookMap);
    userService.editFromRentingHistoryReturned(rentingHistory);
    edit(rentingHistory);
  }

  void edit(RentingHistory rentingHistory) {
    if (rentingHistory == null) return;
    rentingHistoryListCubit.edit(rentingHistory);
    rentingHistoryListBloc.add(ListEvent.edit(rentingHistory));
    print("${rentingHistory.toJson()}");
    update(rentingHistory, CRUDActionType.edit);
  }

  void addList(List<RentingHistory> addList) {
    if (addList == null) return;
    rentingHistoryListCubit.addList(addList);
    rentingHistoryListBloc.add(ListEvent.addList(addList));
    update(addList, CRUDActionType.addList);
  }

  void remove(RentingHistory rentingHistory) {
    if (rentingHistory == null) return;
    rentingHistoryListCubit.remove(rentingHistory);
    rentingHistoryListBloc.add(ListEvent.remove(rentingHistory));
    print("${rentingHistory.toJson()}");
    update(rentingHistory, CRUDActionType.remove);
  }

  List<RentingHistory> search(String query) {
    query = query.trim().toLowerCase();

    if (query == "") return [];

    List<RentingHistory> res = getList().where((rentingHistory) {
      if (rentingHistory.id == query) return true;
      if (rentingHistory.borrowBy == query) return true;
      return false;
    }).toList();

    return res ?? [];
  }

  @override
  Future<void> update(dynamic data, CRUDActionType actionType,
      {bool isMock = false}) async {
    if (actionType == CRUDActionType.add) {
      db.rentingHistory.add(data);
      await api.rentingHistory.add(data);
    } else if (actionType == CRUDActionType.addList) {
      db.rentingHistory.addList(data);
      await api.rentingHistory.addList(data);
    } else if (actionType == CRUDActionType.remove) {
      db.rentingHistory.remove(data);
      await api.rentingHistory.remove(data);
    } else if (actionType == CRUDActionType.edit) {
      db.rentingHistory.edit(data);
      await api.rentingHistory.edit(data);
    }
  }

  @override
  RentingHistory getDataById(String id) {
    RentingHistory res = getList().firstWhere((data) => data.id == id);
    return res;
  }

  @override
  List<RentingHistory> getListDataByListId(List<String> idList) {
    List<RentingHistory> data = [];
    getList().forEach((e) {
      if (idList.contains(e.id)) data.add(e);
    });
    return data;
  }

  List<RentingHistory> getListDataByISBN(String isbn) {
    List<RentingHistory> data = [];
    getList().forEach((e) {
      if (e.bookMap.containsKey(isbn)) data.add(e);
    });
    return data;
  }

  @override
  List<RentingHistory> getList() => rentingHistoryListCubit.list ?? [];
}
