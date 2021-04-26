// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'diagram_node_config_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DiagramNodeConfigStateTearOff {
  const _$DiagramNodeConfigStateTearOff();

  _Initial initial() {
    return const _Initial();
  }

  _Done done(DiagramNode node) {
    return _Done(
      node,
    );
  }
}

/// @nodoc
const $DiagramNodeConfigState = _$DiagramNodeConfigStateTearOff();

/// @nodoc
mixin _$DiagramNodeConfigState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(DiagramNode node) done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(DiagramNode node)? done,
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
abstract class $DiagramNodeConfigStateCopyWith<$Res> {
  factory $DiagramNodeConfigStateCopyWith(DiagramNodeConfigState value,
          $Res Function(DiagramNodeConfigState) then) =
      _$DiagramNodeConfigStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$DiagramNodeConfigStateCopyWithImpl<$Res>
    implements $DiagramNodeConfigStateCopyWith<$Res> {
  _$DiagramNodeConfigStateCopyWithImpl(this._value, this._then);

  final DiagramNodeConfigState _value;
  // ignore: unused_field
  final $Res Function(DiagramNodeConfigState) _then;
}

/// @nodoc
abstract class _$InitialCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) then) =
      __$InitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$InitialCopyWithImpl<$Res>
    extends _$DiagramNodeConfigStateCopyWithImpl<$Res>
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
    return 'DiagramNodeConfigState.initial()';
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
    required TResult Function(DiagramNode node) done,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(DiagramNode node)? done,
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

abstract class _Initial implements DiagramNodeConfigState {
  const factory _Initial() = _$_Initial;
}

/// @nodoc
abstract class _$DoneCopyWith<$Res> {
  factory _$DoneCopyWith(_Done value, $Res Function(_Done) then) =
      __$DoneCopyWithImpl<$Res>;
  $Res call({DiagramNode node});
}

/// @nodoc
class __$DoneCopyWithImpl<$Res>
    extends _$DiagramNodeConfigStateCopyWithImpl<$Res>
    implements _$DoneCopyWith<$Res> {
  __$DoneCopyWithImpl(_Done _value, $Res Function(_Done) _then)
      : super(_value, (v) => _then(v as _Done));

  @override
  _Done get _value => super._value as _Done;

  @override
  $Res call({
    Object? node = freezed,
  }) {
    return _then(_Done(
      node == freezed
          ? _value.node
          : node // ignore: cast_nullable_to_non_nullable
              as DiagramNode,
    ));
  }
}

/// @nodoc

class _$_Done implements _Done {
  const _$_Done(this.node);

  @override
  final DiagramNode node;

  @override
  String toString() {
    return 'DiagramNodeConfigState.done(node: $node)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Done &&
            (identical(other.node, node) ||
                const DeepCollectionEquality().equals(other.node, node)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(node);

  @JsonKey(ignore: true)
  @override
  _$DoneCopyWith<_Done> get copyWith =>
      __$DoneCopyWithImpl<_Done>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(DiagramNode node) done,
  }) {
    return done(node);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(DiagramNode node)? done,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(node);
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

abstract class _Done implements DiagramNodeConfigState {
  const factory _Done(DiagramNode node) = _$_Done;

  DiagramNode get node => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$DoneCopyWith<_Done> get copyWith => throw _privateConstructorUsedError;
}
