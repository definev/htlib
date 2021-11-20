import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  static call(String? number) => launch("tel:$number");
  static message(String? number) => launch("sms:$number");
}
