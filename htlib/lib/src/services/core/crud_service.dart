abstract class CRUDService<T> {
  void add(T data);

  void remove(T data);

  void addList(List<T> dataList);

  T getDataById(String id);

  List<T> getList();

  Future<void> update(dynamic data, CRUDActionType actionType,
      {bool isMock = true});
}

enum CRUDActionType { add, addList, remove }
