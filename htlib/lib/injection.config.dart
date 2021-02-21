// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'src/services/book_service.dart';
import 'src/services/borrowing_history_service.dart';
import 'src/api/htlib_api.dart';
import 'src/db/htlib_db.dart';
import 'src/services/user_service.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  gh.factory<HtlibApi>(() => HtlibApi());

  // Eager singletons must be registered in the right order
  gh.singletonAsync<HtlibDb>(() => HtlibDb.getDb(), signalsReady: true);
  gh.singletonAsync<BookService>(() => BookService.getBookService(),
      dependsOn: [HtlibDb], signalsReady: true);
  gh.singletonAsync<BorrowingHistoryService>(
      () => BorrowingHistoryService.getBorrowingHistoryService(),
      dependsOn: [HtlibDb],
      signalsReady: true);
  gh.singletonAsync<UserService>(() => UserService.getUserService(),
      dependsOn: [HtlibDb], signalsReady: true);
  return get;
}
