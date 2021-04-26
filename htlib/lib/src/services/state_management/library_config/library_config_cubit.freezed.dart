// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'library_config_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$LibraryConfigStateTearOff {
  const _$LibraryConfigStateTearOff();

  _Initial initial() {
    return const _Initial();
  }

  _Done done(LibraryConfig config) {
    return _Done(
      config,
    );
  }
}

/// @nodoc
const $LibraryConfigState = _$LibraryConfigStateTearOff();

/// @nodoc
mixin _$LibraryConfigState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(LibraryConfig config) done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(LibraryConfig config)? done,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Done value) done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Done value)? done,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LibraryConfigStateCopyWith<$Res> {
  factory $LibraryConfigStateCopyWith(
          LibraryConfigState value, $Res Function(LibraryConfigState) then) =
      _$LibraryConfigStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$LibraryConfigStateCopyWithImpl<$Res>
    implements $LibraryConfigStateCopyWith<$Res> {
  _$LibraryConfigStateCopyWithImpl(this._value, this._then);

  final LibraryConfigState _value;
  // ignore: unused_field
  final $Res Function(LibraryConfigState) _then;
}

/// @nodoc
abstract class _$InitialCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) then) =
      __$InitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$InitialCopyWithImpl<$Res>
    extends _$LibraryConfigStateCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(_Initial _value, $Res Function(_Initial) _then)
      : super(_value, (v) => _then(v as _Initial));

  @override
  _Initial get _value => super._value as _Initial;
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial();

  @override
  String toString() {
    return 'LibraryConfigState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(LibraryConfig config) done,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(LibraryConfig config)? done,
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
    required TResult Function(_Initial value) initial,
    required TResult Function(_Done value) done,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Done value)? done,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements LibraryConfigState {
  const factory _Initial() = _$_Initial;
}

/// @nodoc
abstract class _$DoneCopyWith<$Res> {
  factory _$DoneCopyWith(_Done value, $Res Function(_Done) then) =
      __$DoneCopyWithImpl<$Res>;
  $Res call({LibraryConfig config});
}

/// @nodoc
class __$DoneCopyWithImpl<$Res> extends _$LibraryConfigStateCopyWithImpl<$Res>
    implements _$DoneCopyWith<$Res> {
  __$DoneCopyWithImpl(_Done _value, $Res Function(_Done) _then)
      : super(_value, (v) => _then(v as _Done));

  @override
  _Done get _value => super._value as _Done;

  @override
  $Res call({
    Object? config = freezed,
  }) {
    return _then(_Done(
      config == freezed
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as LibraryConfig,
    ));
  }
}

/// @nodoc

class _$_Done implements _Done {
  const _$_Done(this.config);

  @override
  final LibraryConfig config;

  @override
  String toString() {
    return 'LibraryConfigState.done(config: $config)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Done &&
            (identical(other.config, config) ||
                const DeepCollectionEquality().equals(other.config, config)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(config);

  @JsonKey(ignore: true)
  @override
  _$DoneCopyWith<_Done> get copyWith =>
      __$DoneCopyWithImpl<_Done>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(LibraryConfig config) done,
  }) {
    return done(config);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(LibraryConfig config)? done,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(config);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Done value) done,
  }) {
    return done(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Done value)? done,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(this);
    }
    return orElse();
  }
}

abstract class _Done implements LibraryConfigState {
  const factory _Done(LibraryConfig config) = _$_Done;

  LibraryConfig get config => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$DoneCopyWith<_Done> get copyWith => throw _privateConstructorUsedError;
}
