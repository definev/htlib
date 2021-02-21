import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get_it/get_it.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/borrowing_history.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:injectable/injectable.dart';

GetIt getIt = GetIt.instance;

@Singleton(dependsOn: [HtlibDb], signalsReady: true)
class BorrowingHistoryService implements CRUDService<BorrowingHistory> {
  @factoryMethod
  static Future<BorrowingHistoryService> getBorrowingHistoryService() async {
    BorrowingHistoryService borrowingHistoryService = BorrowingHistoryService();
    await borrowingHistoryService.init();
    return borrowingHistoryService;
  }

  ListBloc<BorrowingHistory> borrowingHistoryListBloc;

  Future<void> init() async {
    borrowingHistoryListBloc = ListBloc<BorrowingHistory>();

    List<BorrowingHistory> _list = [];
    if (GetPlatform.isDesktop) {
      _list = getIt<HtlibDb>().borrowingHistory.getList();
    } else {
      try {
        _list = await getIt<HtlibApi>().borrowingHistory.getList();
        getIt<HtlibDb>().borrowingHistory.addList(_list, override: true);
      } catch (_) {
        _list = getIt<HtlibDb>().borrowingHistory.getList();
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
      getIt<HtlibDb>().borrowingHistory.add(data);
      if (!isMock) await getIt<HtlibApi>().borrowingHistory.add(data);
    } else if (actionType == CRUDActionType.addList) {
      getIt<HtlibDb>().borrowingHistory.addList(data);
      if (!isMock) await getIt<HtlibApi>().borrowingHistory.addList(data);
    } else if (actionType == CRUDActionType.remove) {
      getIt<HtlibDb>().borrowingHistory.remove(data);
      if (!isMock) await getIt<HtlibApi>().borrowingHistory.remove(data);
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
