abstract class CRUDDb<T> {
  void add(T data);

  void edit(T data);

  void remove(T data);

  void addList(List<T> dataList);

  List<T> getList();

  T? getDataById(String id);
}
