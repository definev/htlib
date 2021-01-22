import 'package:htlib/app/data/user.dart';
import 'package:htlib/app/db/core_db.dart';

class UserDb extends CoreDb {
  UserDb() : super("UserDb", adapter: [UserAdapter()]);
}
