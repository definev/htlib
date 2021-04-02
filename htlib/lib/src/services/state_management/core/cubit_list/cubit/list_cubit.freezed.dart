// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

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
    required TResult initial(),
    required TResult waiting(),
    required TResult done(List<T> list),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial()?,
    TResult waiting()?,
    TResult done(List<T> list)?,
    required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    required TResult initial(_Initial<T> value),
    required TResult waiting(_Waiting<T> value),
    required TResult done(_Done<T> value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_Initial<T> value)?,
    TResult waiting(_Waiting<T> value)?,
    TResult done(_Done<T> value)?,
    required TResult orElse(),
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
    required TResult initial(),
    required TResult waiting(),
    required TResult done(List<T> list),
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial()?,
    TResult waiting()?,
    TResult done(List<T> list)?,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    required TResult initial(_Initial<T> value),
    required TResult waiting(_Waiting<T> value),
    required TResult done(_Done<T> value),
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_Initial<T> value)?,
    TResult waiting(_Waiting<T> value)?,
    TResult done(_Done<T> value)?,
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
  TResult when<TResult extends Object>({
    required TResult initial(),
    required TResult waiting(),
    required TResult done(List<T> list),
  }) {
    return waiting();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial()?,
    TResult waiting()?,
    TResult done(List<T> list)?,
    required TResult orElse(),
  }) {
    if (waiting != null) {
      return waiting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    required TResult initial(_Initial<T> value),
    required TResult waiting(_Waiting<T> value),
    required TResult done(_Done<T> value),
  }) {
    return waiting(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_Initial<T> value)?,
    TResult waiting(_Waiting<T> value)?,
    TResult done(_Done<T> value)?,
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
  $Res call({List<T>? list});
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
      list == freezed ? _value.list : (list as List<T>?)!,
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
  TResult when<TResult extends Object>({
    required TResult initial(),
    required TResult waiting(),
    required TResult done(List<T> list),
  }) {
    return done(list);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial()?,
    TResult waiting()?,
    TResult done(List<T> list)?,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(list);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    required TResult initial(_Initial<T> value),
    required TResult waiting(_Waiting<T> value),
    required TResult done(_Done<T> value),
  }) {
    return done(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_Initial<T> value)?,
    TResult waiting(_Waiting<T> value)?,
    TResult done(_Done<T> value)?,
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

  List<T> get list;
  @JsonKey(ignore: true)
  _$DoneCopyWith<T, _Done<T>> get copyWith;
}
