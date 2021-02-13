import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/db/core_db.dart';

class UserDb extends CoreDb {
  UserDb() : super("UserDb", adapter: [UserAdapter()]);

  List<User> getList() {
    List<User> _res = this
        .box
        .values
        .where((e) {
          if (e is User) return true;
          return false;
        })
        .toList()
        .cast();

    return _res ?? [];
  }
}
