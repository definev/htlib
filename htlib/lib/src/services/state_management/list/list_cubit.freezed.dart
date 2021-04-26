// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ListStateTearOff {
  const _$ListStateTearOff();

  _Initial<T> initial<T>() {
    return _Initial<T>();
  }

  _Waiting<T> waiting<T>() {
    return _Waiting<T>();
  }

  _Done<T> done<T>(List<T> list) {
    return _Done<T>(
      list,
    );
  }
}

/// @nodoc
const $ListState = _$ListStateTearOff();

/// @nodoc
mixin _$ListState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() waiting,
    required TResult Function(List<T> list) done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? waiting,
    TResult Function(List<T> list)? done,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(_Waiting<T> value) waiting,
    required TResult Function(_Done<T> value) done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(_Waiting<T> value)? waiting,
    TResult Function(_Done<T> value)? done,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
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
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() waiting,
    required TResult Function(List<T> list) done,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? waiting,
    TResult Function(List<T> list)? done,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(_Waiting<T> value) waiting,
    required TResult Function(_Done<T> value) done,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(_Waiting<T> value)? waiting,
    TResult Function(_Done<T> value)? done,
    required TResult orElse(),
  }) {
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
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() waiting,
    required TResult Function(List<T> list) done,
  }) {
    return waiting();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? waiting,
    TResult Function(List<T> list)? done,
    required TResult orElse(),
  }) {
    if (waiting != null) {
      return waiting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(_Waiting<T> value) waiting,
    required TResult Function(_Done<T> value) done,
  }) {
    return waiting(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(_Waiting<T> value)? waiting,
    TResult Function(_Done<T> value)? done,
    required TResult orElse(),
  }) {
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
    Object? list = freezed,
  }) {
    return _then(_Done<T>(
      list == freezed
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc

class _$_Done<T> implements _Done<T> {
  const _$_Done(this.list);

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
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() waiting,
    required TResult Function(List<T> list) done,
  }) {
    return done(list);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? waiting,
    TResult Function(List<T> list)? done,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(list);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(_Waiting<T> value) waiting,
    required TResult Function(_Done<T> value) done,
  }) {
    return done(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(_Waiting<T> value)? waiting,
    TResult Function(_Done<T> value)? done,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(this);
    }
    return orElse();
  }
}

abstract class _Done<T> implements ListState<T> {
  const factory _Done(List<T> list) = _$_Done<T>;

  List<T> get list => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$DoneCopyWith<T, _Done<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
