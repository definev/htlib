import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/model/user.dart';

class SingleUserService extends ChangeNotifier {
  SingleUserService(this._user);

  static Future<SingleUserService> getService() async {
    final student = await Get.find<HtlibApi>()
        .student
        .getDataByPhone(auth.FirebaseAuth.instance.currentUser!.email!.split('@').first);
    return SingleUserService(student!);
  }

  User _user;
  User get user => _user;

  HtlibApi api = Get.find<HtlibApi>();

  void updateUser(User newUser) {
    _user = newUser;
    api.student.edit(newUser);
    notifyListeners();
  }
}
