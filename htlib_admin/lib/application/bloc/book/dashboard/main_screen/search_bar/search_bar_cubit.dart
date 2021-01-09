import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_bar_state.dart';
part 'search_bar_cubit.freezed.dart';

class SearchBarCubit extends Cubit<SearchBarState> {
  bool _focusState = false;
  TextEditingController _searchTextController = TextEditingController();

  bool get focusState => _focusState;
  TextEditingController get searchTextController => _searchTextController;

  SearchBarCubit() : super(SearchBarState.unFocusText());

  void unFocusText(BuildContext context) {
    if (_focusState) {
      _focusState = false;
      FocusScope.of(context).unfocus();
      emit(SearchBarState.unFocusText());
    }
  }

  void focusText(BuildContext context) {
    _focusState = true;
  }
}
