import 'package:htlib_admin/services/.core/base_service.dart';

class AppService extends BaseService<dynamic> {
  AppService() : super("AppService");

  String get locale => read("locale") ?? "vi_VN";
  set locale(String value) => write("locale", value);
}
