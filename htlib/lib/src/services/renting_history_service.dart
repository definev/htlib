import 'package:get/get.dart';
import 'package:get/get_utils/src/platform/platform.dart';

import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton(dependsOn: [HtlibDb], signalsReady: true)
class RentingHistoryService implements CRUDService<RentingHistory> {
  @factoryMethod
  static Future<RentingHistoryService> getService() async {
    RentingHistoryService rentingHistoryService = RentingHistoryService();
    await rentingHistoryService.init();
    return rentingHistoryService;
  }

  ListBloc<RentingHistory> rentingHistoryListBloc;

  Future<void> init() async {
    rentingHistoryListBloc = ListBloc<RentingHistory>();

    List<RentingHistory> _list = [];
    if (GetPlatform.isDesktop) {
      _list = Get.find<HtlibDb>().rentingHistory.getList();
    } else {
      try {
        _list = await Get.find<HtlibApi>().rentingHistory.getList();
        Get.find<HtlibDb>().rentingHistory.addList(_list, override: true);
      } catch (_) {
        _list = Get.find<HtlibDb>().rentingHistory.getList();
      }
    }

    rentingHistoryListBloc.add(ListEvent.addList(_list));
  }

  void add(RentingHistory rentingHistory) {
    rentingHistoryListBloc.add(ListEvent.add(rentingHistory));
    update(rentingHistory, CRUDActionType.add);
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
      {bool isMock = true}) async {
    if (actionType == CRUDActionType.add) {
      Get.find<HtlibDb>().rentingHistory.add(data);
      if (!isMock) await Get.find<HtlibApi>().rentingHistory.add(data);
    } else if (actionType == CRUDActionType.addList) {
      Get.find<HtlibDb>().rentingHistory.addList(data);
      if (!isMock) await Get.find<HtlibApi>().rentingHistory.addList(data);
    } else if (actionType == CRUDActionType.remove) {
      Get.find<HtlibDb>().rentingHistory.remove(data);
      if (!isMock) await Get.find<HtlibApi>().rentingHistory.remove(data);
    }
  }

  @override
  RentingHistory getDataById(String id) {
    RentingHistory res = getList().firstWhere((data) => data.id == id);
    return res;
  }

  @override
  List<RentingHistory> getList() => rentingHistoryListBloc.list ?? [];
}
