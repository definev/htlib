import 'package:diacritic/diacritic.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get_it/get_it.dart';
import 'package:htlib/_internal/utils/error_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/services/core/crud_service.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:injectable/injectable.dart';

GetIt getIt = GetIt.instance;

@Singleton(dependsOn: [HtlibDb], signalsReady: true)
class UserService implements CRUDService<User> {
  @factoryMethod
  static Future<UserService> getUserService() async {
    UserService userService = UserService();
    await userService.init();
    return userService;
  }

  ListBloc<User> userListBloc;

  Future<void> init() async {
    userListBloc = ListBloc<User>();
    List<User> _list = [];

    if (GetPlatform.isWindows) {
      _list = getIt<HtlibDb>().user.getList();
    } else {
      try {
        _list = await getIt<HtlibApi>().user.getList();
        getIt<HtlibDb>().user.addList(_list, override: true);
      } catch (_) {
        _list = getIt<HtlibDb>().user.getList();
      }
    }

    userListBloc.add(ListEvent.addList(_list));
  }

  bool _compare(String e1, String e2) {
    e1 = removeDiacritics(e1.toLowerCase());
    e2 = removeDiacritics(e2.toLowerCase());
    if (e2.contains(e1)) return true;
    return false;
  }

  List<User> searchUser(String query) {
    List<User> _res = getList().where((user) {
      if (query.trim() == "") return false;
      if (_compare(query, user.name)) return true;
      if (_compare(query, user.currentClass)) return true;
      if (_compare(query, user.phone)) return true;
      return false;
    }).toList();

    return _res;
  }

  List<User> getBorrowedUserByISBN(String isbn) {
    List<User> _res = getList()
        .where((user) => user.borrowingBookList.contains(isbn))
        .toList();
    return _res;
  }

  void add(User user) {
    userListBloc.add(ListEvent.add(user));
    update(user, CRUDActionType.add);
  }

  void addList(List<User> addList) {
    userListBloc.add(ListEvent.addList(addList));
    update(addList, CRUDActionType.addList);
  }

  void remove(User user) {
    userListBloc.add(ListEvent.remove(user));
    update(user, CRUDActionType.remove);
  }

  @override
  Future<void> update(dynamic data, CRUDActionType actionType,
      {bool isMock = false}) async {
    if (actionType == CRUDActionType.add) {
      getIt<HtlibDb>().borrowingHistory.add(data);
      if (!isMock) await getIt<HtlibApi>().borrowingHistory.add(data);
    } else if (actionType == CRUDActionType.addList) {
      getIt<HtlibDb>().borrowingHistory.addList(data);
      if (!isMock) await getIt<HtlibApi>().borrowingHistory.addList(data);
    } else if (actionType == CRUDActionType.remove) {
      getIt<HtlibDb>().borrowingHistory.remove(data);
      if (!isMock) await getIt<HtlibApi>().borrowingHistory.remove(data);
    }
  }

  @override
  User getDataById(String id) {
    User res = getList().firstWhere((data) => data.id == id);
    return res;
  }

  @override
  List<User> getList() => userListBloc.list ?? [];
}
