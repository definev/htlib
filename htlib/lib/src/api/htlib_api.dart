import 'package:htlib/src/api/firebase/firebase.dart' as fb;
import 'package:injectable/injectable.dart';

@injectable
class HtlibApi {
  fb.FirebaseBookApi book = fb.FirebaseBookApi();
  fb.FirebaseUserApi user = fb.FirebaseUserApi();
  fb.BorrowingHistoryApi borrowingHistory = fb.BorrowingHistoryApi();
}
