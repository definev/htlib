import 'package:htlib/src/db/core/crud_db.dart';
import 'package:htlib/src/db/core/core_db.dart';
import 'package:htlib/src/model/renting_history.dart';

class RentingHistoryDb extends CoreDb<RentingHistory?>
    implements CRUDDb<RentingHistory?> {
  RentingHistoryDb() : super("RentingHistoryDb");

  void add(RentingHistory? rentingHistory) =>
      this.write(rentingHistory!.id, rentingHistory);

  void edit(RentingHistory? rentingHistory) =>
      this.write(rentingHistory!.id, rentingHistory);

  void addList(List<RentingHistory?> rentingHistoryList,
      {bool override = false}) {
    rentingHistoryList.forEach((rentingHistory) {
      if (override == false) {
        bool inDb = this.box!.values.contains(rentingHistory);
        if (!inDb) add(rentingHistory);
      } else {
        add(rentingHistory);
      }
    });
  }

  void remove(RentingHistory? rentingHistory) => this.delete(rentingHistory!.id);

  void removeList(List<RentingHistory> rentingHistoryList) =>
      rentingHistoryList.forEach((b) => remove(b));

  List<RentingHistory> getList() {
    List<RentingHistory> res = this
        .box!
        .values
        .where((e) {
          if (e is RentingHistory) return true;
          return false;
        })
        .toList()
        .cast();

    return res;
  }

  RentingHistory? getDataById(String id) => this.read(id);
}
