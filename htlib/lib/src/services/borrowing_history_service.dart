import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:htlib/src/model/borrowing_history.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:injectable/injectable.dart';

GetIt getIt = GetIt.instance;

@injectable
class BorrowingHistoryService {
  List<BorrowingHistory> _list = [];

  @factoryMethod
  static Future<BorrowingHistoryService> getBorrowingHistoryService() async {
    BorrowingHistoryService borrowingHistoryService = BorrowingHistoryService();
    await borrowingHistoryService.init();
    return borrowingHistoryService;
  }

  Future<void> init() async {
    ;
    var data = await getIt<HtlibApi>().borrowingHistory.getList();
    _list = data.fold(
      (l) {
        log("BorrowingHistory SERVICE: ${l.toString()}");
        return _list;
      },
      (r) => r,
    );

    getIt<HtlibApi>()
        .borrowingHistory
        .borrowingHistoryStream
        .listen((newList) => _list = newList);
  }
}
