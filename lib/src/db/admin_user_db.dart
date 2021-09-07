import 'package:htlib/src/model/admin_user.dart';

import 'core/core_db.dart';
import 'core/crud_db.dart';

class AdminUserDb extends CoreDb<AdminUser> implements CRUDDb<AdminUser> {
  AdminUserDb() : super("AdminUserDb");

  void add(AdminUser adminUser) => this.write(adminUser.email, adminUser);

  void edit(AdminUser adminUser) => this.write(adminUser.email, adminUser);

  void addList(List<AdminUser> adminUserList, {bool override = false}) {
    adminUserList.forEach((adminUser) {
      if (override == false) {
        bool inDb = this.box!.values.contains(adminUser);
        if (!inDb) add(adminUser);
      } else {
        add(adminUser);
      }
    });
  }

  void remove(AdminUser adminUser) => this.delete(adminUser.email);

  void removeList(List<AdminUser> adminUserList) => adminUserList.forEach((b) => remove(b));

  List<AdminUser> getList() {
    List<AdminUser> res = box!.values
        .where((e) {
          if (e is AdminUser) return true;
          return false;
        })
        .toList()
        .cast();

    return res;
  }

  AdminUser? getDataById(String id) => this.read(id);
}
