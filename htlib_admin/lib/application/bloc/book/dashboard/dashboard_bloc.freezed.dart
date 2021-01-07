// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'dashboard_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$DashboardEventTearOff {
  const _$DashboardEventTearOff();

// ignore: unused_element
  _Started started() {
    return const _Started();
  }

// ignore: unused_element
  _GetBookList getBookList() {
    return const _GetBookList();
  }
}

/// @nodoc
// ignore: unused_element
const $DashboardEvent = _$DashboardEventTearOff();

/// @nodoc
mixin _$DashboardEvent {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result started(),
    @required Result getBookList(),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result started(),
    Result getBookList(),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result started(_Started value),
    @required Result getBookList(_GetBookList value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result started(_Started value),
    Result getBookList(_GetBookList value),
    @required Result orElse(),
  });
}

/// @nodoc
abstract class $DashboardEventCopyWith<$Res> {
  factory $DashboardEventCopyWith(
          DashboardEvent value, $Res Function(DashboardEvent) then) =
      _$DashboardEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$DashboardEventCopyWithImpl<$Res>
    implements $DashboardEventCopyWith<$Res> {
  _$DashboardEventCopyWithImpl(this._value, this._then);

  final DashboardEvent _value;
  // ignore: unused_field
  final $Res Function(DashboardEvent) _then;
}

/// @nodoc
abstract class _$StartedCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) then) =
      __$StartedCopyWithImpl<$Res>;
}

/// @nodoc
class __$StartedCopyWithImpl<$Res> extends _$DashboardEventCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(_Started _value, $Res Function(_Started) _then)
      : super(_value, (v) => _then(v as _Started));

  @override
  _Started get _value => super._value as _Started;
}

/// @nodoc
class _$_Started with DiagnosticableTreeMixin implements _Started {
  const _$_Started();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardEvent.started()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'DashboardEvent.started'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Started);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result started(),
    @required Result getBookList(),
  }) {
    assert(started != null);
    assert(getBookList != null);
    return started();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result started(),
    Result getBookList(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result started(_Started value),
    @required Result getBookList(_GetBookList value),
  }) {
    assert(started != null);
    assert(getBookList != null);
    return started(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result started(_Started value),
    Result getBookList(_GetBookList value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements DashboardEvent {
  const factory _Started() = _$_Started;
}

/// @nodoc
abstract class _$GetBookListCopyWith<$Res> {
  factory _$GetBookListCopyWith(
          _GetBookList value, $Res Function(_GetBookList) then) =
      __$GetBookListCopyWithImpl<$Res>;
}

/// @nodoc
class __$GetBookListCopyWithImpl<$Res>
    extends _$DashboardEventCopyWithImpl<$Res>
    implements _$GetBookListCopyWith<$Res> {
  __$GetBookListCopyWithImpl(
      _GetBookList _value, $Res Function(_GetBookList) _then)
      : super(_value, (v) => _then(v as _GetBookList));

  @override
  _GetBookList get _value => super._value as _GetBookList;
}

/// @nodoc
class _$_GetBookList with DiagnosticableTreeMixin implements _GetBookList {
  const _$_GetBookList();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardEvent.getBookList()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'DashboardEvent.getBookList'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _GetBookList);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result started(),
    @required Result getBookList(),
  }) {
    assert(started != null);
    assert(getBookList != null);
    return getBookList();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result started(),
    Result getBookList(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (getBookList != null) {
      return getBookList();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result started(_Started value),
    @required Result getBookList(_GetBookList value),
  }) {
    assert(started != null);
    assert(getBookList != null);
    return getBookList(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result started(_Started value),
    Result getBookList(_GetBookList value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (getBookList != null) {
      return getBookList(this);
    }
    return orElse();
  }
}

abstract class _GetBookList implements DashboardEvent {
  const factory _GetBookList() = _$_GetBookList;
}

/// @nodoc
class _$DashboardStateTearOff {
  const _$DashboardStateTearOff();

// ignore: unused_element
  _Initial initial() {
    return const _Initial();
  }

// ignore: unused_element
  _SuccessGetBookList successGetBookList(List<Book> bookList) {
    return _SuccessGetBookList(
      bookList,
    );
  }

// ignore: unused_element
  _DataFailure dataFailure(String errCode) {
    return _DataFailure(
      errCode,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $DashboardState = _$DashboardStateTearOff();

/// @nodoc
mixin _$DashboardState {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result successGetBookList(List<Book> bookList),
    @required Result dataFailure(String errCode),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result successGetBookList(List<Book> bookList),
    Result dataFailure(String errCode),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(_Initial value),
    @required Result successGetBookList(_SuccessGetBookList value),
    @required Result dataFailure(_DataFailure value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(_Initial value),
    Result successGetBookList(_SuccessGetBookList value),
    Result dataFailure(_DataFailure value),
    @required Result orElse(),
  });
}

/// @nodoc
abstract class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(
          DashboardState value, $Res Function(DashboardState) then) =
      _$DashboardStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._value, this._then);

  final DashboardState _value;
  // ignore: unused_field
  final $Res Function(DashboardState) _then;
}

/// @nodoc
abstract class _$InitialCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) then) =
      __$InitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> extends _$DashboardStateCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(_Initial _value, $Res Function(_Initial) _then)
      : super(_value, (v) => _then(v as _Initial));

  @override
  _Initial get _value => super._value as _Initial;
}

/// @nodoc
class _$_Initial with DiagnosticableTreeMixin implements _Initial {
  const _$_Initial();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardState.initial()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'DashboardState.initial'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result successGetBookList(List<Book> bookList),
    @required Result dataFailure(String errCode),
  }) {
    assert(initial != null);
    assert(successGetBookList != null);
    assert(dataFailure != null);
    return initial();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result successGetBookList(List<Book> bookList),
    Result dataFailure(String errCode),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(_Initial value),
    @required Result successGetBookList(_SuccessGetBookList value),
    @required Result dataFailure(_DataFailure value),
  }) {
    assert(initial != null);
    assert(successGetBookList != null);
    assert(dataFailure != null);
    return initial(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(_Initial value),
    Result successGetBookList(_SuccessGetBookList value),
    Result dataFailure(_DataFailure value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements DashboardState {
  const factory _Initial() = _$_Initial;
}

/// @nodoc
abstract class _$SuccessGetBookListCopyWith<$Res> {
  factory _$SuccessGetBookListCopyWith(
          _SuccessGetBookList value, $Res Function(_SuccessGetBookList) then) =
      __$SuccessGetBookListCopyWithImpl<$Res>;
  $Res call({List<Book> bookList});
}

/// @nodoc
class __$SuccessGetBookListCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res>
    implements _$SuccessGetBookListCopyWith<$Res> {
  __$SuccessGetBookListCopyWithImpl(
      _SuccessGetBookList _value, $Res Function(_SuccessGetBookList) _then)
      : super(_value, (v) => _then(v as _SuccessGetBookList));

  @override
  _SuccessGetBookList get _value => super._value as _SuccessGetBookList;

  @override
  $Res call({
    Object bookList = freezed,
  }) {
    return _then(_SuccessGetBookList(
      bookList == freezed ? _value.bookList : bookList as List<Book>,
    ));
  }
}

/// @nodoc
class _$_SuccessGetBookList
    with DiagnosticableTreeMixin
    implements _SuccessGetBookList {
  const _$_SuccessGetBookList(this.bookList) : assert(bookList != null);

  @override
  final List<Book> bookList;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardState.successGetBookList(bookList: $bookList)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DashboardState.successGetBookList'))
      ..add(DiagnosticsProperty('bookList', bookList));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SuccessGetBookList &&
            (identical(other.bookList, bookList) ||
                const DeepCollectionEquality()
                    .equals(other.bookList, bookList)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(bookList);

  @override
  _$SuccessGetBookListCopyWith<_SuccessGetBookList> get copyWith =>
      __$SuccessGetBookListCopyWithImpl<_SuccessGetBookList>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result successGetBookList(List<Book> bookList),
    @required Result dataFailure(String errCode),
  }) {
    assert(initial != null);
    assert(successGetBookList != null);
    assert(dataFailure != null);
    return successGetBookList(bookList);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result successGetBookList(List<Book> bookList),
    Result dataFailure(String errCode),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (successGetBookList != null) {
      return successGetBookList(bookList);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(_Initial value),
    @required Result successGetBookList(_SuccessGetBookList value),
    @required Result dataFailure(_DataFailure value),
  }) {
    assert(initial != null);
    assert(successGetBookList != null);
    assert(dataFailure != null);
    return successGetBookList(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(_Initial value),
    Result successGetBookList(_SuccessGetBookList value),
    Result dataFailure(_DataFailure value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (successGetBookList != null) {
      return successGetBookList(this);
    }
    return orElse();
  }
}

abstract class _SuccessGetBookList implements DashboardState {
  const factory _SuccessGetBookList(List<Book> bookList) =
      _$_SuccessGetBookList;

  List<Book> get bookList;
  _$SuccessGetBookListCopyWith<_SuccessGetBookList> get copyWith;
}

/// @nodoc
abstract class _$DataFailureCopyWith<$Res> {
  factory _$DataFailureCopyWith(
          _DataFailure value, $Res Function(_DataFailure) then) =
      __$DataFailureCopyWithImpl<$Res>;
  $Res call({String errCode});
}

/// @nodoc
class __$DataFailureCopyWithImpl<$Res>
    extends _$DashboardStateCopyWithImpl<$Res>
    implements _$DataFailureCopyWith<$Res> {
  __$DataFailureCopyWithImpl(
      _DataFailure _value, $Res Function(_DataFailure) _then)
      : super(_value, (v) => _then(v as _DataFailure));

  @override
  _DataFailure get _value => super._value as _DataFailure;

  @override
  $Res call({
    Object errCode = freezed,
  }) {
    return _then(_DataFailure(
      errCode == freezed ? _value.errCode : errCode as String,
    ));
  }
}

/// @nodoc
class _$_DataFailure with DiagnosticableTreeMixin implements _DataFailure {
  const _$_DataFailure(this.errCode) : assert(errCode != null);

  @override
  final String errCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DashboardState.dataFailure(errCode: $errCode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DashboardState.dataFailure'))
      ..add(DiagnosticsProperty('errCode', errCode));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DataFailure &&
            (identical(other.errCode, errCode) ||
                const DeepCollectionEquality().equals(other.errCode, errCode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(errCode);

  @override
  _$DataFailureCopyWith<_DataFailure> get copyWith =>
      __$DataFailureCopyWithImpl<_DataFailure>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result successGetBookList(List<Book> bookList),
    @required Result dataFailure(String errCode),
  }) {
    assert(initial != null);
    assert(successGetBookList != null);
    assert(dataFailure != null);
    return dataFailure(errCode);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result successGetBookList(List<Book> bookList),
    Result dataFailure(String errCode),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (dataFailure != null) {
      return dataFailure(errCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(_Initial value),
    @required Result successGetBookList(_SuccessGetBookList value),
    @required Result dataFailure(_DataFailure value),
  }) {
    assert(initial != null);
    assert(successGetBookList != null);
    assert(dataFailure != null);
    return dataFailure(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(_Initial value),
    Result successGetBookList(_SuccessGetBookList value),
    Result dataFailure(_DataFailure value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (dataFailure != null) {
      return dataFailure(this);
    }
    return orElse();
  }
}

abstract class _DataFailure implements DashboardState {
  const factory _DataFailure(String errCode) = _$_DataFailure;

  String get errCode;
  _$DataFailureCopyWith<_DataFailure> get copyWith;
}
