import 'package:htlib/src/api/firebase/firebase.dart' as fb;

class HtlibApi {
  fb.FirebaseBookApi book = fb.FirebaseBookApi();
  fb.FirebaseUserApi user = fb.FirebaseUserApi();
  fb.RentingHistoryApi rentingHistory = fb.RentingHistoryApi();
  fb.LoginApi login = fb.LoginApi();
}
