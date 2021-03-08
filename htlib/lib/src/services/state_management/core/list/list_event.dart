part of 'list_bloc.dart';

@freezed
abstract class ListEvent<T> with _$ListEvent {
  const factory ListEvent.started() = _Started;
  const factory ListEvent.add(T data) = _Add;
  const factory ListEvent.edit(T data) = _Edit;
  const factory ListEvent.remove(T data) = _Remove;
  const factory ListEvent.addList(List<T> dataList) = _MergeList;
}
