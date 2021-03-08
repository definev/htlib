import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_event.dart';
part 'list_state.dart';
part 'list_bloc.freezed.dart';

class ListBloc<T> extends Bloc<ListEvent<T>, ListState<T>> {
  ListBloc() : super(_Initial());

  List<T> _list = [];

  List<T> get list => _list ?? [];

  ListState<T> _started() => ListState<T>.initial();

  ListState<T> _addFunc(T data) {
    _list.add(data);
    List<T> res = [..._list];
    return ListState<T>.done(res);
  }

  ListState<T> _removeFunc(T data) {
    _list.removeWhere((element) => element == data);
    List<T> res = [..._list];
    return ListState<T>.done(res);
  }

  ListState<T> _addList(List<T> dataList) {
    _list.addAll(dataList);
    List<T> res = [..._list];
    return ListState<T>.done(res);
  }

  ListState<T> _editFunc(T data) {
    int index = _list.indexOf(data);
    _list[index] = data;
    List<T> res = [..._list];
    return ListState<T>.done(res);
  }

  @override
  Stream<ListState<T>> mapEventToState(
    ListEvent<T> event,
  ) async* {
    yield event.when<ListState<T>>(
      started: _started,
      add: _addFunc,
      remove: _removeFunc,
      addList: _addList,
      edit: _editFunc,
    );
  }
}
