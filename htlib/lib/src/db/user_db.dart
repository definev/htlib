import 'package:htlib/src/db/core/crud_db.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/db/core/core_db.dart';

class UserDb extends CoreDb<User> implements CRUDDb<User> {
  UserDb() : super("UserDb");

  void add(User user) => this.write(user.id, user);

  void edit(User user) => this.write(user.id, user);

  void addList(List<User> userList, {bool override = false}) {
    userList.forEach((user) {
      if (override == false) {
        bool inDb = this.box!.values.contains(user);
        if (!inDb) add(user);
      } else {
        add(user);
      }
    });
  }

  void remove(User user) => this.delete(user.id);

  List<User> getList() {
    List<User> res = this
        .box!
        .values
        .where((e) {
          if (e is User) return true;
          return false;
        })
        .toList()
        .cast();

    return res;
  }

  User getDataById(String id) => this.read(id);
}
