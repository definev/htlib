import 'package:htlib_admin/domain/book/entities/book_catagory.dart';
import 'package:htlib_admin/domain/book/entities/book.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib_admin/domain/book/facade/i_book_facade.dart';
import 'package:htlib_admin/domain/book/value_errors/book_error.dart';
// ignore: unused_import
import 'package:htlib_admin/domain/core/extentions.dart';
import 'package:htlib_admin/infrastructure/book/local/mock_local_book.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IBookFacade)
class BookFacadeImpl implements IBookFacade {
  final LocalBook _localBook;

  BookFacadeImpl(this._localBook);

  BookError checkNull(dynamic object) {
    var checkNull = object.haveNullValue();
    if (checkNull["isNull"]) {
      return BookErrors.emptyField(checkNull["nullField"]);
    }
    return null;
  }

  @override
  Future<Either<BookError, Unit>> createBook(Book book) async {
    if (book.bookCatagoryList.isEmpty) {
      return left(BookErrors.emptyBookCategory());
    }

    BookError nullError = checkNull(book);
    if (nullError != null) return left(nullError);

    //TODO: implement createBook

    return right(unit);
  }

  @override
  Future<Either<BookError, Unit>> createBookCatagory(
      BookCatagory bookCatagory) async {
    BookError nullError = checkNull(bookCatagory);
    if (nullError != null) return left(nullError);

    //TODO: implement createBookCatagory

    return right(unit);
  }

  @override
  Future<Either<BookError, Unit>> deleteBook(String id) async {
    // TODO: implement deleteBook

    return right(unit);
  }

  @override
  Future<Either<BookError, Unit>> deleteBookCatagory(String id) async {
    // TODO: implement deleteBookCatagory
    return right(unit);
  }

  @override
  Future<Either<BookError, List<Book>>> getAllBookList() async {
    // TODO: implement getAllBookList

    List<Book> bookList = await _localBook.getBookList();

    return right(bookList);
  }

  @override
  Future<Either<BookError, List<Book>>> getBookListByCatagory(
      BookCatagory bookCatagory) async {
    // TODO: implement getBookListByCatagory
    throw UnimplementedError();
  }

  @override
  Future<Either<BookError, List<BookCatagory>>> getListBookCategory() async {
    // TODO: implement getListBookCategory
    throw UnimplementedError();
  }

  @override
  Future<Either<BookError, Unit>> updateBook(Book book) async {
    // TODO: implement updateBook
    throw UnimplementedError();
  }

  @override
  Future<Either<BookError, Unit>> updateBookCatagory(
      BookCatagory bookCatagory) async {
    // TODO: implement updateBookCatagory
    throw UnimplementedError();
  }
}
