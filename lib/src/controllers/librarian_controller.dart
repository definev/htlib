import 'dart:async';

import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:htlib/src/utils/class_utils.dart';
import 'package:riverpod/riverpod.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/model/admin_user.dart';

final librarianControllerProvider =
    StateNotifierProvider<LibrarianController, AsyncValue<List<List<AdminUser?>>>>((ref) {
  return LibrarianController();
});

class LibrarianController extends StateController<AsyncValue<List<List<AdminUser?>>>> {
  LibrarianController() : super(AsyncValue.loading()) {
    init();
  }

  HtlibApi api = Get.find();
  StreamSubscription<List<List<AdminUser?>>>? _mornitorStream;

  @override
  void dispose() {
    _mornitorStream?.cancel();
    super.dispose();
  }

  void init() async {
    _mornitorStream = api.admin.allMornitorStream.listen((data) => state = AsyncValue.data(data));
    state = AsyncValue.data(await api.admin.getAllMornitor());
  }

  Future<bool> addMornitor(AdminUser user) async {
    List<List<AdminUser?>> data = List.from(state.data!.value);

    final matrixCoordinate = ClassUtils.parseClassNameToMatrix(user.className!);
    data[matrixCoordinate.value1][matrixCoordinate.value2] = user;
    state = AsyncValue.data(data);
    return await api.admin.addMornitor(user);
  }
}
