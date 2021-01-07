// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'infrastructure/book/facade/i_book_facade.dart';
import 'infrastructure/core/book_injectable_module.dart';
import 'application/bloc/book/dashboard/dashboard_bloc.dart';
import 'domain/book/facade/i_book_facade.dart';
import 'infrastructure/book/local/mock_local_book.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final bookInjectableModule = _$BookInjectableModule();
  gh.lazySingleton<LocalBook>(() => bookInjectableModule.localBook);
  gh.lazySingleton<IBookFacade>(() => BookFacadeImpl(get<LocalBook>()));
  gh.factory<DashboardBloc>(() => DashboardBloc(get<IBookFacade>()));
  return get;
}

class _$BookInjectableModule extends BookInjectableModule {}
