abstract class CRUDApi<T> {
  Future<void> add(T data);

  Future<void> edit(T data);

  Future<void> remove(T data);

  Future<void> addList(List<T> dataList) async {}

  Future<List<T>> getList() async {
    throw UnimplementedError();
  }

  Stream<List<T>> get stream {
    throw "don't have concrete for subcribe for $T";
  }

  Future<T?> getDataById(String id);
}
