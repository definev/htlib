abstract class CRUDApi<T> {
  Future<void> add(T data);

  Future<void> edit(T data);

  Future<void> remove(T data);

  Future<void> addList(List<T> dataList);

  Future<List<T>> getList();

  Stream<List<T>>? get stream {
    throw "don't have concrete for subcribe for $T";
  }

  Future<T?> getDataById(String id);
}
