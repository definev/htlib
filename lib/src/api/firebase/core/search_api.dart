abstract class SearchApi<T> {
  Stream<T> searchStream();

  Future<T> query(String data);

  Future<void> onSearchDone();

  Future<void> addSearch(String data);
}
