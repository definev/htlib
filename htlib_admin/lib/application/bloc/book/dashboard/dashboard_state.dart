part of 'dashboard_bloc.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;
  const factory DashboardState.successGetBookList(List<Book> bookList) =
      _SuccessGetBookList;
  const factory DashboardState.dataFailure(String errCode) = _DataFailure;
}
