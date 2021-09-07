import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_state.dart';
part 'list_cubit.freezed.dart';

typedef bool CompareFunc<T>(T prev, T curr);

class ListCubit<T> extends Cubit<ListState<T>> {
  ListCubit() : super(ListState.initial());

  final List<T> _list = [];
  List<T> get list => _list;

  void add(T data) {
    _list.add(data);
    var res = [..._list];
    emit(ListState.done(List.from(res)));
  }

  void remove(T data, {required CompareFunc<T> where}) {
    _list.removeWhere((prev) => where(prev, data));
    var res = [..._list];
    emit(ListState.done(List.from(res)));
  }

  void addList(List<T> dataList) {
    _list.addAll(dataList);
    var res = [..._list];
    emit(ListState.done(List.from(res)));
  }

  void edit(T data, {required CompareFunc<T> where}) {
    int _index = _list.indexWhere((prev) => where(prev, data));
    _list.removeWhere((prev) => where(prev, data));
    var res = [..._list];
    emit(ListState.done(List.from(res)));

    if (_index == -1) {
      _list.add(data);
    } else {
      _list.insert(_index, data);
    }
    res = [..._list];
    emit(ListState.done(List.from(res)));
  }
}
