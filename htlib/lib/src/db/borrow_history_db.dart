import 'package:htlib/src/db/core/crud_db.dart';
import 'package:htlib/src/db/core_db.dart';
import 'package:htlib/src/model/borrowing_history.dart';

class BorrowingHistoryDb extends CoreDb<BorrowingHistory>
    implements CRUDDb<BorrowingHistory> {
  BorrowingHistoryDb()
      : super("BorrowingHistoryDb", adapter: [BorrowingHistoryAdapter()]);

  void add(BorrowingHistory borrowingHistory) =>
      this.write(borrowingHistory.id, borrowingHistory);

  void addList(List<BorrowingHistory> borrowingHistoryList,
      {bool override = false}) {
    borrowingHistoryList.forEach((borrowingHistory) {
      if (override == false) {
        bool inDb = this.box.values.contains(borrowingHistory);
        if (!inDb) add(borrowingHistory);
      } else {
        add(borrowingHistory);
      }
    });
  }

  void remove(BorrowingHistory borrowingHistory) =>
      this.delete(borrowingHistory.id);

  void removeList(List<BorrowingHistory> borrowingHistoryList) =>
      borrowingHistoryList.forEach((b) => remove(b));

  List<BorrowingHistory> getList() {
    List<BorrowingHistory> res = this
        .box
        .values
        .where((e) {
          if (e is BorrowingHistory) return true;
          return false;
        })
        .toList()
        .cast();

    return res;
  }

  BorrowingHistory getDataById(String id) => this.read(id);
}
