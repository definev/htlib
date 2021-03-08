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
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:injectable/injectable.dart';

@Singleton(dependsOn: [HtlibDb], signalsReady: true)
class RentingHistoryService implements CRUDService<RentingHistory> {
  @factoryMethod
  static Future<RentingHistoryService> getService() async {
    RentingHistoryService rentingHistoryService = RentingHistoryService();
    await rentingHistoryService.init();
    return rentingHistoryService;
  }

  HtlibApi api = Get.find<HtlibApi>();
  HtlibDb db = Get.find<HtlibDb>();
  BookService bookService = Get.find();
  UserService userService = Get.find();

  ListBloc<RentingHistory> rentingHistoryListBloc;

  Future<void> init() async {
    rentingHistoryListBloc = ListBloc<RentingHistory>();

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

    _list.add(RentingHistory.random());

    rentingHistoryListBloc.add(ListEvent.addList(_list));
  }

  Future<void> addAsync(
    RentingHistory rentingHistory, {
    User user,
    List<String> bookList,
    List<Book> allBookList,
  }) async {
    await add(rentingHistory);

    List<String> _userBookList = user.bookList;
    _userBookList.addAll(bookList);

    List<String> _userRentingHistoryList = user.rentingHistoryList;
    _userRentingHistoryList.add(rentingHistory.id);

    user = user.copyWith(
      bookList: _userBookList,
      rentingHistoryList: _userRentingHistoryList,
    );
    userService.edit(user);

    Map<String, int> _bookMap = bookService.processISBNList(bookList);

    _bookMap.forEach((key, value) {
      int i = allBookList.indexWhere((e) => e.isbn == key);
      bookService.edit(allBookList[i]);
    });
  }

  void add(RentingHistory rentingHistory) {
    rentingHistoryListBloc.add(ListEvent.add(rentingHistory));
    update(rentingHistory, CRUDActionType.add);
  }

  void returnAsync(RentingHistory rentingHistory) async {
    rentingHistory =
        rentingHistory.copyWith(state: RentingHistoryStateCode.returned.index);
    bookService.editFromISBNList(rentingHistory.bookList);

    edit(rentingHistory);
  }

  void edit(RentingHistory rentingHistory) {
    rentingHistoryListBloc.add(ListEvent<RentingHistory>.edit(rentingHistory));
    update(rentingHistory, CRUDActionType.edit);
  }

  void addList(List<RentingHistory> addList) {
    rentingHistoryListBloc.add(ListEvent.addList(addList));
    update(addList, CRUDActionType.addList);
  }

  void remove(RentingHistory rentingHistory) {
    rentingHistoryListBloc.add(ListEvent.remove(rentingHistory));
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
      if (e.bookList.contains(isbn)) data.add(e);
    });
    return data;
  }

  @override
  List<RentingHistory> getList() => rentingHistoryListBloc.list ?? [];
}
