// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'book_list_view_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$BookListViewStateTearOff {
  const _$BookListViewStateTearOff();

// ignore: unused_element
  _CloseBook closeBook() {
    return const _CloseBook();
  }

// ignore: unused_element
  _OpenBook openBook(Book book) {
    return _OpenBook(
      book,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $BookListViewState = _$BookListViewStateTearOff();

/// @nodoc
mixin _$BookListViewState {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult closeBook(),
    @required TResult openBook(Book book),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult closeBook(),
    TResult openBook(Book book),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult closeBook(_CloseBook value),
    @required TResult openBook(_OpenBook value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult closeBook(_CloseBook value),
    TResult openBook(_OpenBook value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $BookListViewStateCopyWith<$Res> {
  factory $BookListViewStateCopyWith(
          BookListViewState value, $Res Function(BookListViewState) then) =
      _$BookListViewStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$BookListViewStateCopyWithImpl<$Res>
    implements $BookListViewStateCopyWith<$Res> {
  _$BookListViewStateCopyWithImpl(this._value, this._then);

  final BookListViewState _value;
  // ignore: unused_field
  final $Res Function(BookListViewState) _then;
}

/// @nodoc
abstract class _$CloseBookCopyWith<$Res> {
  factory _$CloseBookCopyWith(
          _CloseBook value, $Res Function(_CloseBook) then) =
      __$CloseBookCopyWithImpl<$Res>;
}

/// @nodoc
class __$CloseBookCopyWithImpl<$Res>
    extends _$BookListViewStateCopyWithImpl<$Res>
    implements _$CloseBookCopyWith<$Res> {
  __$CloseBookCopyWithImpl(_CloseBook _value, $Res Function(_CloseBook) _then)
      : super(_value, (v) => _then(v as _CloseBook));

  @override
  _CloseBook get _value => super._value as _CloseBook;
}

/// @nodoc
class _$_CloseBook implements _CloseBook {
  const _$_CloseBook();

  @override
  String toString() {
    return 'BookListViewState.closeBook()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _CloseBook);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult closeBook(),
    @required TResult openBook(Book book),
  }) {
    assert(closeBook != null);
    assert(openBook != null);
    return closeBook();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult closeBook(),
    TResult openBook(Book book),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (closeBook != null) {
      return closeBook();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult closeBook(_CloseBook value),
    @required TResult openBook(_OpenBook value),
  }) {
    assert(closeBook != null);
    assert(openBook != null);
    return closeBook(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult closeBook(_CloseBook value),
    TResult openBook(_OpenBook value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (closeBook != null) {
      return closeBook(this);
    }
    return orElse();
  }
}

abstract class _CloseBook implements BookListViewState {
  const factory _CloseBook() = _$_CloseBook;
}

/// @nodoc
abstract class _$OpenBookCopyWith<$Res> {
  factory _$OpenBookCopyWith(_OpenBook value, $Res Function(_OpenBook) then) =
      __$OpenBookCopyWithImpl<$Res>;
  $Res call({Book book});
}

/// @nodoc
class __$OpenBookCopyWithImpl<$Res>
    extends _$BookListViewStateCopyWithImpl<$Res>
    implements _$OpenBookCopyWith<$Res> {
  __$OpenBookCopyWithImpl(_OpenBook _value, $Res Function(_OpenBook) _then)
      : super(_value, (v) => _then(v as _OpenBook));

  @override
  _OpenBook get _value => super._value as _OpenBook;

  @override
  $Res call({
    Object book = freezed,
  }) {
    return _then(_OpenBook(
      book == freezed ? _value.book : book as Book,
    ));
  }
}

/// @nodoc
class _$_OpenBook implements _OpenBook {
  const _$_OpenBook(this.book) : assert(book != null);

  @override
  final Book book;

  @override
  String toString() {
    return 'BookListViewState.openBook(book: $book)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _OpenBook &&
            (identical(other.book, book) ||
                const DeepCollectionEquality().equals(other.book, book)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(book);

  @override
  _$OpenBookCopyWith<_OpenBook> get copyWith =>
      __$OpenBookCopyWithImpl<_OpenBook>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult closeBook(),
    @required TResult openBook(Book book),
  }) {
    assert(closeBook != null);
    assert(openBook != null);
    return openBook(book);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult closeBook(),
    TResult openBook(Book book),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (openBook != null) {
      return openBook(book);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult closeBook(_CloseBook value),
    @required TResult openBook(_OpenBook value),
  }) {
    assert(closeBook != null);
    assert(openBook != null);
    return openBook(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult closeBook(_CloseBook value),
    TResult openBook(_OpenBook value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (openBook != null) {
      return openBook(this);
    }
    return orElse();
  }
}

abstract class _OpenBook implements BookListViewState {
  const factory _OpenBook(Book book) = _$_OpenBook;

  Book get book;
  _$OpenBookCopyWith<_OpenBook> get copyWith;
}
