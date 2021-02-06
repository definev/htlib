import 'package:get/get.dart';
import 'package:htlib/_internal/utils/error_utils.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/db/htlib_db.dart';
import 'package:htlib/app/repositories/htlib_repos.dart';

class BookService {
  List<BookBase> _list = [];
  List<BookBase> get list => _list ?? [];

  void clearList() => _list = [];

  void mergeList(List<BookBase> addList) {
    _list.addAll(addList);
    _list = _list.toSet().toList();
    HtlibDb.book.addList(addList, override: true);
    HtlibRepos.book.addList(_list);
  }

  Future<void> init() async {
    if (GetPlatform.isWindows) {
      _list = HtlibDb.book.getList();
    } else {
      await ErrorUtils.catchNetworkError(
        onConnected: () async {
          _list = await HtlibRepos.book.getList();
        },
        onError: () {
          _list = HtlibDb.book.getList();
        },
      );
    }
  }
}
