import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/model/admin_user.dart';

final librarianControllerProvider = StateNotifierProvider<LibrarianController, AsyncValue<List<List<AdminUser?>>>>((ref) {
  return LibrarianController();
});

class LibrarianController extends StateController<AsyncValue<List<List<AdminUser?>>>> {
  LibrarianController() : super(AsyncValue.loading()) {
    init();
  }

  HtlibApi api = Get.find();

  void init() async {
    state = AsyncValue.data(await api.admin.getAllMornitor());
  }
}
