import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/state_management/list/list_cubit.dart';

class AdminService extends CRUDService<AdminUser> {
  HtlibApi api = Get.find<HtlibApi>();
  HtlibDb db = Get.find<HtlibDb>();

  ListCubit<AdminUser> adminUser = ListCubit();

  late AdminUser currentUser;

  static Future<AdminService> getService() async {
    AdminService adminService = AdminService();
    await adminService.init();
    return adminService;
  }

  Future<void> init() async {
    adminUser = ListCubit<AdminUser>();

    List<AdminUser> _list = [];

    if (kIsWeb) {
      _list = await api.admin.getList();
    } else {
      try {
        _list = await api.admin.getList();
        db.admin.addList(_list, override: true);
      } catch (_) {
        _list = db.admin.getList();
      }
    }
    try {
      currentUser = _list.where((u) {
        return u.email == FirebaseAuth.instance.currentUser!.email;
      }).first;
      adminUser.addList(_list);
    } catch (e) {
      currentUser = AdminUser(
        uid: 'sdasdasdqwd',
        name: 'Ngô Thanh Thủy Ngân',
        email: 'thuvienhanthuyen@gmail.com',
        phone: '0929623960',
        adminType: AdminType.librarian,
      );
      currentUser = currentUser.copyWith(imageUrl: 'https://thispersondoesnotexist.com/image');
    }
  }

  @override
  void add(AdminUser data) {
    adminUser.add(data);
    api.admin.add(data);
    db.admin.add(data);
  }

  @override
  void addList(List<AdminUser> dataList) {
    adminUser.addList(dataList);
    api.admin.addList(dataList);
    db.admin.addList(dataList);
  }

  @override
  void edit(AdminUser data) {
    adminUser.edit(data);
    api.admin.edit(data);
  }

  @override
  AdminUser? getDataById(String id) {
    return db.admin.getDataById(id);
  }

  @override
  List<AdminUser> getList() {
    return adminUser.list;
  }

  @override
  List<AdminUser> getListDataByListId(List<String> idList) {
    throw UnimplementedError();
  }

  @override
  void remove(AdminUser data) {
    adminUser.remove(data);
    api.admin.remove(data);
  }
}
