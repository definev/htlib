// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'list_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ListEventTearOff {
  const _$ListEventTearOff();

// ignore: unused_element
  _Started<T> started<T>() {
    return _Started<T>();
  }

// ignore: unused_element
  _Add<T> add<T>(T data) {
    return _Add<T>(
      data,
    );
  }

// ignore: unused_element
  _Remove<T> remove<T>(T data) {
    return _Remove<T>(
      data,
    );
  }

// ignore: unused_element
  _MergeList<T> addList<T>(List<T> dataList) {
    return _MergeList<T>(
      dataList,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $ListEvent = _$ListEventTearOff();

/// @nodoc
mixin _$ListEvent<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult started(),
    @required TResult add(T data),
    @required TResult remove(T data),
    @required TResult addList(List<T> dataList),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult started(),
    TResult add(T data),
    TResult remove(T data),
    TResult addList(List<T> dataList),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult started(_Started<T> value),
    @required TResult add(_Add<T> value),
    @required TResult remove(_Remove<T> value),
    @required TResult addList(_MergeList<T> value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult started(_Started<T> value),
    TResult add(_Add<T> value),
    TResult remove(_Remove<T> value),
    TResult addList(_MergeList<T> value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $ListEventCopyWith<T, $Res> {
  factory $ListEventCopyWith(
          ListEvent<T> value, $Res Function(ListEvent<T>) then) =
      _$ListEventCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ListEventCopyWithImpl<T, $Res> implements $ListEventCopyWith<T, $Res> {
  _$ListEventCopyWithImpl(this._value, this._then);

  final ListEvent<T> _value;
  // ignore: unused_field
  final $Res Function(ListEvent<T>) _then;
}

/// @nodoc
abstract class _$StartedCopyWith<T, $Res> {
  factory _$StartedCopyWith(
          _Started<T> value, $Res Function(_Started<T>) then) =
      __$StartedCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$StartedCopyWithImpl<T, $Res> extends _$ListEventCopyWithImpl<T, $Res>
    implements _$StartedCopyWith<T, $Res> {
  __$StartedCopyWithImpl(_Started<T> _value, $Res Function(_Started<T>) _then)
      : super(_value, (v) => _then(v as _Started<T>));

  @override
  _Started<T> get _value => super._value as _Started<T>;
}

/// @nodoc
class _$_Started<T> implements _Started<T> {
  const _$_Started();

  @override
  String toString() {
    return 'ListEvent<$T>.started()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Started<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult started(),
    @required TResult add(T data),
    @required TResult remove(T data),
    @required TResult addList(List<T> dataList),
  }) {
    assert(started != null);
    assert(add != null);
    assert(remove != null);
    assert(addList != null);
    return started();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult started(),
    TResult add(T data),
    TResult remove(T data),
    TResult addList(List<T> dataList),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult started(_Started<T> value),
    @required TResult add(_Add<T> value),
    @required TResult remove(_Remove<T> value),
    @required TResult addList(_MergeList<T> value),
  }) {
    assert(started != null);
    assert(add != null);
    assert(remove != null);
    assert(addList != null);
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult started(_Started<T> value),
    TResult add(_Add<T> value),
    TResult remove(_Remove<T> value),
    TResult addList(_MergeList<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started<T> implements ListEvent<T> {
  const factory _Started() = _$_Started<T>;
}

/// @nodoc
abstract class _$AddCopyWith<T, $Res> {
  factory _$AddCopyWith(_Add<T> value, $Res Function(_Add<T>) then) =
      __$AddCopyWithImpl<T, $Res>;
  $Res call({T data});
}

/// @nodoc
class __$AddCopyWithImpl<T, $Res> extends _$ListEventCopyWithImpl<T, $Res>
    implements _$AddCopyWith<T, $Res> {
  __$AddCopyWithImpl(_Add<T> _value, $Res Function(_Add<T>) _then)
      : super(_value, (v) => _then(v as _Add<T>));

  @override
  _Add<T> get _value => super._value as _Add<T>;

  @override
  $Res call({
    Object data = freezed,
  }) {
    return _then(_Add<T>(
      data == freezed ? _value.data : data as T,
    ));
  }
}

/// @nodoc
class _$_Add<T> implements _Add<T> {
  const _$_Add(this.data) : assert(data != null);

  @override
  final T data;

  @override
  String toString() {
    return 'ListEvent<$T>.add(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Add<T> &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(data);

  @JsonKey(ignore: true)
  @override
  _$AddCopyWith<T, _Add<T>> get copyWith =>
      __$AddCopyWithImpl<T, _Add<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult started(),
    @required TResult add(T data),
    @required TResult remove(T data),
    @required TResult addList(List<T> dataList),
  }) {
    assert(started != null);
    assert(add != null);
    assert(remove != null);
    assert(addList != null);
    return add(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult started(),
    TResult add(T data),
    TResult remove(T data),
    TResult addList(List<T> dataList),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (add != null) {
      return add(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult started(_Started<T> value),
    @required TResult add(_Add<T> value),
    @required TResult remove(_Remove<T> value),
    @required TResult addList(_MergeList<T> value),
  }) {
    assert(started != null);
    assert(add != null);
    assert(remove != null);
    assert(addList != null);
    return add(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult started(_Started<T> value),
    TResult add(_Add<T> value),
    TResult remove(_Remove<T> value),
    TResult addList(_MergeList<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (add != null) {
      return add(this);
    }
    return orElse();
  }
}

abstract class _Add<T> implements ListEvent<T> {
  const factory _Add(T data) = _$_Add<T>;

  T get data;
  @JsonKey(ignore: true)
  _$AddCopyWith<T, _Add<T>> get copyWith;
}

/// @nodoc
abstract class _$RemoveCopyWith<T, $Res> {
  factory _$RemoveCopyWith(_Remove<T> value, $Res Function(_Remove<T>) then) =
      __$RemoveCopyWithImpl<T, $Res>;
  $Res call({T data});
}

/// @nodoc
class __$RemoveCopyWithImpl<T, $Res> extends _$ListEventCopyWithImpl<T, $Res>
    implements _$RemoveCopyWith<T, $Res> {
  __$RemoveCopyWithImpl(_Remove<T> _value, $Res Function(_Remove<T>) _then)
      : super(_value, (v) => _then(v as _Remove<T>));

  @override
  _Remove<T> get _value => super._value as _Remove<T>;

  @override
  $Res call({
    Object data = freezed,
  }) {
    return _then(_Remove<T>(
      data == freezed ? _value.data : data as T,
    ));
  }
}

/// @nodoc
class _$_Remove<T> implements _Remove<T> {
  const _$_Remove(this.data) : assert(data != null);

  @override
  final T data;

  @override
  String toString() {
    return 'ListEvent<$T>.remove(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Remove<T> &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(data);

  @JsonKey(ignore: true)
  @override
  _$RemoveCopyWith<T, _Remove<T>> get copyWith =>
      __$RemoveCopyWithImpl<T, _Remove<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult started(),
    @required TResult add(T data),
    @required TResult remove(T data),
    @required TResult addList(List<T> dataList),
  }) {
    assert(started != null);
    assert(add != null);
    assert(remove != null);
    assert(addList != null);
    return remove(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult started(),
    TResult add(T data),
    TResult remove(T data),
    TResult addList(List<T> dataList),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (remove != null) {
      return remove(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult started(_Started<T> value),
    @required TResult add(_Add<T> value),
    @required TResult remove(_Remove<T> value),
    @required TResult addList(_MergeList<T> value),
  }) {
    assert(started != null);
    assert(add != null);
    assert(remove != null);
    assert(addList != null);
    return remove(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult started(_Started<T> value),
    TResult add(_Add<T> value),
    TResult remove(_Remove<T> value),
    TResult addList(_MergeList<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (remove != null) {
      return remove(this);
    }
    return orElse();
  }
}

abstract class _Remove<T> implements ListEvent<T> {
  const factory _Remove(T data) = _$_Remove<T>;

  T get data;
  @JsonKey(ignore: true)
  _$RemoveCopyWith<T, _Remove<T>> get copyWith;
}

/// @nodoc
abstract class _$MergeListCopyWith<T, $Res> {
  factory _$MergeListCopyWith(
          _MergeList<T> value, $Res Function(_MergeList<T>) then) =
      __$MergeListCopyWithImpl<T, $Res>;
  $Res call({List<T> dataList});
}

/// @nodoc
class __$MergeListCopyWithImpl<T, $Res> extends _$ListEventCopyWithImpl<T, $Res>
    implements _$MergeListCopyWith<T, $Res> {
  __$MergeListCopyWithImpl(
      _MergeList<T> _value, $Res Function(_MergeList<T>) _then)
      : super(_value, (v) => _then(v as _MergeList<T>));

  @override
  _MergeList<T> get _value => super._value as _MergeList<T>;

  @override
  $Res call({
    Object dataList = freezed,
  }) {
    return _then(_MergeList<T>(
      dataList == freezed ? _value.dataList : dataList as List<T>,
    ));
  }
}

/// @nodoc
class _$_MergeList<T> implements _MergeList<T> {
  const _$_MergeList(this.dataList) : assert(dataList != null);

  @override
  final List<T> dataList;

  @override
  String toString() {
    return 'ListEvent<$T>.addList(dataList: $dataList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MergeList<T> &&
            (identical(other.dataList, dataList) ||
                const DeepCollectionEquality()
                    .equals(other.dataList, dataList)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(dataList);

  @JsonKey(ignore: true)
  @override
  _$MergeListCopyWith<T, _MergeList<T>> get copyWith =>
      __$MergeListCopyWithImpl<T, _MergeList<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult started(),
    @required TResult add(T data),
    @required TResult remove(T data),
    @required TResult addList(List<T> dataList),
  }) {
    assert(started != null);
    assert(add != null);
    assert(remove != null);
    assert(addList != null);
    return addList(dataList);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult started(),
    TResult add(T data),
    TResult remove(T data),
    TResult addList(List<T> dataList),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (addList != null) {
      return addList(dataList);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult started(_Started<T> value),
    @required TResult add(_Add<T> value),
    @required TResult remove(_Remove<T> value),
    @required TResult addList(_MergeList<T> value),
  }) {
    assert(started != null);
    assert(add != null);
    assert(remove != null);
    assert(addList != null);
    return addList(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult started(_Started<T> value),
    TResult add(_Add<T> value),
    TResult remove(_Remove<T> value),
    TResult addList(_MergeList<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (addList != null) {
      return addList(this);
    }
    return orElse();
  }
}

abstract class _MergeList<T> implements ListEvent<T> {
  const factory _MergeList(List<T> dataList) = _$_MergeList<T>;

  List<T> get dataList;
  @JsonKey(ignore: true)
  _$MergeListCopyWith<T, _MergeList<T>> get copyWith;
}

/// @nodoc
class _$ListStateTearOff {
  const _$ListStateTearOff();

// ignore: unused_element
  _Initial<T> initial<T>() {
    return _Initial<T>();
  }

// ignore: unused_element
  _Waiting<T> waiting<T>() {
    return _Waiting<T>();
  }

// ignore: unused_element
  _Done<T> done<T>(List<T> list) {
    return _Done<T>(
      list,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $ListState = _$ListStateTearOff();

/// @nodoc
mixin _$ListState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult waiting(),
    @required TResult done(List<T> list),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult waiting(),
    TResult done(List<T> list),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_Initial<T> value),
    @required TResult waiting(_Waiting<T> value),
    @required TResult done(_Done<T> value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_Initial<T> value),
    TResult waiting(_Waiting<T> value),
    TResult done(_Done<T> value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $ListStateCopyWith<T, $Res> {
  factory $ListStateCopyWith(
          ListState<T> value, $Res Function(ListState<T>) then) =
      _$ListStateCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ListStateCopyWithImpl<T, $Res> implements $ListStateCopyWith<T, $Res> {
  _$ListStateCopyWithImpl(this._value, this._then);

  final ListState<T> _value;
  // ignore: unused_field
  final $Res Function(ListState<T>) _then;
}

/// @nodoc
abstract class _$InitialCopyWith<T, $Res> {
  factory _$InitialCopyWith(
          _Initial<T> value, $Res Function(_Initial<T>) then) =
      __$InitialCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$InitialCopyWithImpl<T, $Res> extends _$ListStateCopyWithImpl<T, $Res>
    implements _$InitialCopyWith<T, $Res> {
  __$InitialCopyWithImpl(_Initial<T> _value, $Res Function(_Initial<T>) _then)
      : super(_value, (v) => _then(v as _Initial<T>));

  @override
  _Initial<T> get _value => super._value as _Initial<T>;
}

/// @nodoc
class _$_Initial<T> implements _Initial<T> {
  const _$_Initial();

  @override
  String toString() {
    return 'ListState<$T>.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Initial<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult waiting(),
    @required TResult done(List<T> list),
  }) {
    assert(initial != null);
    assert(waiting != null);
    assert(done != null);
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult waiting(),
    TResult done(List<T> list),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_Initial<T> value),
    @required TResult waiting(_Waiting<T> value),
    @required TResult done(_Done<T> value),
  }) {
    assert(initial != null);
    assert(waiting != null);
    assert(done != null);
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_Initial<T> value),
    TResult waiting(_Waiting<T> value),
    TResult done(_Done<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial<T> implements ListState<T> {
  const factory _Initial() = _$_Initial<T>;
}

/// @nodoc
abstract class _$WaitingCopyWith<T, $Res> {
  factory _$WaitingCopyWith(
          _Waiting<T> value, $Res Function(_Waiting<T>) then) =
      __$WaitingCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$WaitingCopyWithImpl<T, $Res> extends _$ListStateCopyWithImpl<T, $Res>
    implements _$WaitingCopyWith<T, $Res> {
  __$WaitingCopyWithImpl(_Waiting<T> _value, $Res Function(_Waiting<T>) _then)
      : super(_value, (v) => _then(v as _Waiting<T>));

  @override
  _Waiting<T> get _value => super._value as _Waiting<T>;
}

/// @nodoc
class _$_Waiting<T> implements _Waiting<T> {
  const _$_Waiting();

  @override
  String toString() {
    return 'ListState<$T>.waiting()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Waiting<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult waiting(),
    @required TResult done(List<T> list),
  }) {
    assert(initial != null);
    assert(waiting != null);
    assert(done != null);
    return waiting();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult waiting(),
    TResult done(List<T> list),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (waiting != null) {
      return waiting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_Initial<T> value),
    @required TResult waiting(_Waiting<T> value),
    @required TResult done(_Done<T> value),
  }) {
    assert(initial != null);
    assert(waiting != null);
    assert(done != null);
    return waiting(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_Initial<T> value),
    TResult waiting(_Waiting<T> value),
    TResult done(_Done<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (waiting != null) {
      return waiting(this);
    }
    return orElse();
  }
}

abstract class _Waiting<T> implements ListState<T> {
  const factory _Waiting() = _$_Waiting<T>;
}

/// @nodoc
abstract class _$DoneCopyWith<T, $Res> {
  factory _$DoneCopyWith(_Done<T> value, $Res Function(_Done<T>) then) =
      __$DoneCopyWithImpl<T, $Res>;
  $Res call({List<T> list});
}

/// @nodoc
class __$DoneCopyWithImpl<T, $Res> extends _$ListStateCopyWithImpl<T, $Res>
    implements _$DoneCopyWith<T, $Res> {
  __$DoneCopyWithImpl(_Done<T> _value, $Res Function(_Done<T>) _then)
      : super(_value, (v) => _then(v as _Done<T>));

  @override
  _Done<T> get _value => super._value as _Done<T>;

  @override
  $Res call({
    Object list = freezed,
  }) {
    return _then(_Done<T>(
      list == freezed ? _value.list : list as List<T>,
    ));
  }
}

/// @nodoc
class _$_Done<T> implements _Done<T> {
  const _$_Done(this.list) : assert(list != null);

  @override
  final List<T> list;

  @override
  String toString() {
    return 'ListState<$T>.done(list: $list)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Done<T> &&
            (identical(other.list, list) ||
                const DeepCollectionEquality().equals(other.list, list)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(list);

  @JsonKey(ignore: true)
  @override
  _$DoneCopyWith<T, _Done<T>> get copyWith =>
      __$DoneCopyWithImpl<T, _Done<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult waiting(),
    @required TResult done(List<T> list),
  }) {
    assert(initial != null);
    assert(waiting != null);
    assert(done != null);
    return done(list);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult waiting(),
    TResult done(List<T> list),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (done != null) {
      return done(list);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_Initial<T> value),
    @required TResult waiting(_Waiting<T> value),
    @required TResult done(_Done<T> value),
  }) {
    assert(initial != null);
    assert(waiting != null);
    assert(done != null);
    return done(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_Initial<T> value),
    TResult waiting(_Waiting<T> value),
    TResult done(_Done<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (done != null) {
      return done(this);
    }
    return orElse();
  }
}

abstract class _Done<T> implements ListState<T> {
  const factory _Done(List<T> list) = _$_Done<T>;

  List<T> get list;
  @JsonKey(ignore: true)
  _$DoneCopyWith<T, _Done<T>> get copyWith;
}
