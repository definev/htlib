import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:htlib_admin/domain/book/entities/book.dart';
import 'package:htlib_admin/domain/book/facade/i_book_facade.dart';
import 'package:injectable/injectable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';
part 'dashboard_bloc.freezed.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final IBookFacade _bookFacade;
  DashboardBloc(this._bookFacade) : super(_Initial());

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    yield* event.when(
      started: () async* {
        yield DashboardState.initial();
      },
      getBookList: () async* {
        var bookList = await _bookFacade.getAllBookList();
        yield bookList.fold(
          (l) => DashboardState.dataFailure(l.code),
          (r) => DashboardState.successGetBookList(r),
        );
      },
    );
  }
}
