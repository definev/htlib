import 'package:dartz/dartz.dart';
import 'package:htlib_admin/domain/book/entities/book.dart';
import 'package:htlib_admin/domain/book/entities/book_catagory.dart';
import 'package:htlib_admin/domain/book/value_errors/book_error.dart';

abstract class IBookFacade {
  /// Get all Book in database
  Future<Either<BookError, List<Book>>> getAllBookList();

  /// Get book category list
  Future<Either<BookError, List<BookCatagory>>> getListBookCategory();

  /// Get book list by book catagory
  Future<Either<BookError, List<Book>>> getBookListByCatagory(
    BookCatagory bookCatagory,
  );

  /// Create book to database
  Future<Either<BookError, Unit>> createBook(Book book);

  /// Update book to database
  Future<Either<BookError, Unit>> updateBook(Book book);

  /// Delete book to database
  Future<Either<BookError, Unit>> deleteBook(String id);

  /// Create book catagory to database
  Future<Either<BookError, Unit>> createBookCatagory(
    BookCatagory bookCatagory,
  );

  /// Update book catagory to database
  Future<Either<BookError, Unit>> updateBookCatagory(
    BookCatagory bookCatagory,
  );

  /// Delete book catagory to database
  Future<Either<BookError, Unit>> deleteBookCatagory(
    String id,
  );
}
