import 'package:htlib/src/api/firebase/firebase.dart' as fb;

class HtlibApi {
  fb.FirebaseAdminApi admin = fb.FirebaseAdminApi();
  fb.FirebaseBookApi book = fb.FirebaseBookApi();
  fb.FirebaseUserApi user = fb.FirebaseUserApi();
  fb.FirebaseDiagramApi diagram = fb.FirebaseDiagramApi();
  fb.RentingHistoryApi rentingHistory = fb.RentingHistoryApi();
  fb.LoginApi login = fb.LoginApi();
}
