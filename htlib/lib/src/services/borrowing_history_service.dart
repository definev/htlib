import 'package:get/get.dart';
import 'package:get/get_utils/src/platform/platform.dart';

import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/borrowing_history.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton(dependsOn: [HtlibDb], signalsReady: true)
class BorrowingHistoryService implements CRUDService<BorrowingHistory> {
  @factoryMethod
  static Future<BorrowingHistoryService> getService() async {
    BorrowingHistoryService borrowingHistoryService = BorrowingHistoryService();
    await borrowingHistoryService.init();
    return borrowingHistoryService;
  }

  ListBloc<BorrowingHistory> borrowingHistoryListBloc;

  Future<void> init() async {
    borrowingHistoryListBloc = ListBloc<BorrowingHistory>();

    List<BorrowingHistory> _list = [];
    if (GetPlatform.isDesktop) {
      _list = Get.find<HtlibDb>().borrowingHistory.getList();
    } else {
      try {
        _list = await Get.find<HtlibApi>().borrowingHistory.getList();
        Get.find<HtlibDb>().borrowingHistory.addList(_list, override: true);
      } catch (_) {
        _list = Get.find<HtlibDb>().borrowingHistory.getList();
      }
    }

    borrowingHistoryListBloc.add(ListEvent.addList(_list));
  }

  void add(BorrowingHistory borrowingHistory) {
    borrowingHistoryListBloc.add(ListEvent.add(borrowingHistory));
    update(borrowingHistory, CRUDActionType.add);
  }

  void addList(List<BorrowingHistory> addList) {
    borrowingHistoryListBloc.add(ListEvent.addList(addList));
    update(addList, CRUDActionType.addList);
  }

  void remove(BorrowingHistory borrowingHistory) {
    borrowingHistoryListBloc.add(ListEvent.remove(borrowingHistory));
    update(borrowingHistory, CRUDActionType.remove);
  }

  List<BorrowingHistory> search(String query) {
    query = query.trim().toLowerCase();

    if (query == "") return [];

    List<BorrowingHistory> res = getList().where((borrowingHistory) {
      if (borrowingHistory.id == query) return true;
      if (borrowingHistory.borrowBy == query) return true;
      return false;
    }).toList();

    return res ?? [];
  }

  @override
  Future<void> update(dynamic data, CRUDActionType actionType,
      {bool isMock = false}) async {
    if (actionType == CRUDActionType.add) {
      Get.find<HtlibDb>().borrowingHistory.add(data);
      if (!isMock) await Get.find<HtlibApi>().borrowingHistory.add(data);
    } else if (actionType == CRUDActionType.addList) {
      Get.find<HtlibDb>().borrowingHistory.addList(data);
      if (!isMock) await Get.find<HtlibApi>().borrowingHistory.addList(data);
    } else if (actionType == CRUDActionType.remove) {
      Get.find<HtlibDb>().borrowingHistory.remove(data);
      if (!isMock) await Get.find<HtlibApi>().borrowingHistory.remove(data);
    }
  }

  @override
  BorrowingHistory getDataById(String id) {
    BorrowingHistory res = getList().firstWhere((data) => data.id == id);
    return res;
  }

  @override
  List<BorrowingHistory> getList() => borrowingHistoryListBloc.list ?? [];
}
