import 'package:htlib/src/model/renting_history.dart';

class AppConfig {
  static String get title => "Thư viện Hàn Thuyên";
  static String get tabRentingHistory => "Lịch sử mượn";
  static String get tabBook => "Sách";
  static String get tabUser => "Học sinh";
  static String get tabProfile => "Cá nhân";
  static String get tabSetting => "Cài đặt";
  static String get appName => "Htlib";
  static String get version => "1.4.2";
  static String get description => "Phần mềm quản lí thư viện do Bùi Đại Dương A6K73 viết tặng nhà trường.";
  static Map<RentingHistoryStateCode, String> get rentingHistoryCode => {
        RentingHistoryStateCode.renting: "Đang trong thời gian mượn",
        RentingHistoryStateCode.warning: "Sắp hết hạn mượn",
        RentingHistoryStateCode.expired: "Quá hạn mượn",
        RentingHistoryStateCode.returned: "Đã trả",
      };
}
