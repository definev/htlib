import 'package:htlib/src/model/renting_history.dart';

class AppConfig {
  static String get title => "Thư viện Hàn Thuyên";
  static String get tabRentingHistory => "Lịch sử mượn";
  static String get tabBook => "Sách";
  static String get tabUser => "Người mượn";
  static String get version => "1.0.0";
  static Map<RentingHistoryStateCode, String> get rentingHistoryCode => {
        RentingHistoryStateCode.renting: "Đang trong thời gian mượn",
        RentingHistoryStateCode.warning: "Sắp hết hạn mượn",
        RentingHistoryStateCode.expired: "Quá hạn mượn",
        RentingHistoryStateCode.returned: "Đã trả",
      };
}
