import 'dart:async';

abstract class CRUDService<T> {
  void add(T data);

  void edit(T data);

  void remove(T data);

  void addList(List<T> dataList);

  FutureOr<T?> getDataById(String id);
  List<T> getListDataByListId(List<String> idList);

  List<T> getList();
}

enum CRUDActionType { add, addList, remove, edit }
