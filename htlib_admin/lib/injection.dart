import 'package:get_it/get_it.dart';
import 'package:htlib_admin/injection.config.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@injectableInit
void configurationInjection(String env) {
  $initGetIt(getIt, environment: env);
}
