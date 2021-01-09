import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:htlib_admin/domain/book/entities/book.dart';

part 'book_list_view_state.dart';
part 'book_list_view_cubit.freezed.dart';

class BookListViewCubit extends Cubit<BookListViewState> {
  BookListViewCubit() : super(BookListViewState.closeBook());

  void openBook(Book book) => emit(BookListViewState.openBook(book));
  void closeBook() => emit(BookListViewState.closeBook());
}
