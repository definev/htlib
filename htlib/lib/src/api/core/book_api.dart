abstract class BookApi {
  Stream<String> subscribeWaitingList();

  Future<void> deleteWaitingList();
}
