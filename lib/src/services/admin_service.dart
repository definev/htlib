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

  late ValueNotifier<AdminUser> currentUser = ValueNotifier(AdminUser.loading());

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
      _list = await api.admin.getList();
      _list.addAll(await api.admin.getListMornitor());
    } else {
      try {
        _list = [...(await api.admin.getList()), ...(await api.admin.getListMornitor())];
        db.admin.addList(_list, override: true);
      } catch (_) {
        _list = db.admin.getList();
      }
    }
    try {
      currentUser.value = _list.firstWhere((u) => u.email == FirebaseAuth.instance.currentUser!.email);
      adminUser.addList(_list);
    } catch (e) {
      print(e);
      currentUser.value = AdminUser(
        uid: 'sdasdasdqwd',
        name: 'Nguyễn Thị Thanh',
        email: 'thuvienhanthuyen@gmail.com',
        phone: '0929623960',
        adminType: AdminType.librarian,
      );
      currentUser.value = currentUser.value.copyWith(imageUrl: 'https://thispersondoesnotexist.com/image');
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
    // adminUser.edit(data);
    // api.admin.edit(data);
  }

  void editMornitor(AdminUser data) {
    currentUser.value = adminUser.list.firstWhere((u) => u.className == currentUser.value.className);
    if (data.adminType == AdminType.mornitor) api.admin.editMornitor(data);
  }

  void editActiveUserInMornitor(String className, {int? add, int? remove}) {
    try {
      final mornitor = adminUser.list.where((ad) => ad.className == className).first;
      adminUser.edit(
        mornitor.copyWith(activeMemberNumber: mornitor.activeMemberNumber! + (add ?? 0) - (remove ?? 0)),
        where: (prev, curr) => prev.className == prev.className,
      );
      api.admin.editMornitor(
        mornitor.copyWith(activeMemberNumber: mornitor.activeMemberNumber! + (add ?? 0) - (remove ?? 0)),
      );
      if (currentUser.value.adminType == AdminType.mornitor) {
        currentUser.value = adminUser.list.firstWhere((u) => u.className == currentUser.value.className);
      }
    } catch (e) {
      throw Exception('Lớp chưa có lớp trưởng.');
    }
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
    adminUser.remove(data, where: (prev, curr) => prev.className == curr.className);
    api.admin.remove(data);
  }
}
