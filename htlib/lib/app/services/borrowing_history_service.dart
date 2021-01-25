import 'dart:developer';

import 'package:htlib/app/data/borrowing_history.dart';
import 'package:htlib/app/repositories/htlib_repos.dart';

class BorrowingHistoryService {
  List<BorrowingHistory> _list = [];

  Future<void> init() async {
    ;
    var data = await HtlibRepos.borrowingHistory.getList();
    _list = data.fold(
      (l) {
        log("BorrowingHistory SERVICE: ${l.toString()}");
        return _list;
      },
      (r) => r,
    );

    HtlibRepos.borrowingHistory.borrowingHistoryStream
        .listen((newList) => _list = newList);
  }
}
