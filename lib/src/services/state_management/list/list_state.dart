part of 'list_cubit.dart';

@freezed
abstract class ListState<T> with _$ListState {
  const factory ListState.initial() = _Initial;
  const factory ListState.waiting() = _Waiting;
  const factory ListState.done(List<T> list) = _Done;
}
