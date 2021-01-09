part of 'search_bar_cubit.dart';

@freezed
abstract class SearchBarState with _$SearchBarState {
  const factory SearchBarState.focusText() = _FocusText;
  const factory SearchBarState.unFocusText() = _UnFocusText;
}
