import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_state.dart';
part 'list_cubit.freezed.dart';

class ListCubit<T> extends Cubit<ListState<T>> {
  ListCubit() : super(ListState.initial());

  final List<T> _list = [];
  List<T> get list => _list ?? [];

  void add(T data) {
    _list.add(data);
    var res = [..._list];
    emit(ListState.done(List.from(res)));
  }

  void remove(T data) {
    _list.removeWhere((element) => element == data);
    var res = [..._list];
    emit(ListState.done(List.from(res)));
  }

  void addList(List<T> dataList) {
    _list.addAll(dataList);
    var res = [..._list];
    emit(ListState.done(List.from(res)));
  }

  void edit(T data) {
    int _index = _list.indexOf(data);
    _list.remove(data);
    var res = [..._list];
    emit(ListState.done(List.from(res)));

    _list.insert(_index, data);
    res = [..._list];
    emit(ListState.done(List.from(res)));
  }
}
