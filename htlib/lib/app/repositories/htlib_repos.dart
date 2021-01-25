import 'package:htlib/app/repositories/firebase/firebase.dart' as fb;

class HtlibRepos {
  static fb.BookRepo book = fb.BookRepo();
  static fb.UserRepo user = fb.UserRepo();
  static fb.BorrowingHistoryRepo borrowingHistory = fb.BorrowingHistoryRepo();
}
