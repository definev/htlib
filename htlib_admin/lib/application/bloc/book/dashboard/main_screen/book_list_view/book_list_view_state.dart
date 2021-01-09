part of 'book_list_view_cubit.dart';

@freezed
abstract class BookListViewState with _$BookListViewState {
  const factory BookListViewState.closeBook() = _CloseBook;
  const factory BookListViewState.openBook(Book book) = _OpenBook;
}
