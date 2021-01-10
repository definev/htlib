import 'package:hive/hive.dart';
import 'package:htlib_admin/data/.core/adapter_utils.dart';

part 'theme_type.g.dart';

@HiveType(typeId: AdapterUtils.theme)
enum ThemeType {
  @HiveField(0)
  BlueHT,
  @HiveField(1)
  BlueHT_Dark,
}
