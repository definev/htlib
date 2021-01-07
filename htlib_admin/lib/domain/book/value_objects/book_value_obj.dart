import 'package:dartz/dartz.dart';
import 'package:htlib_admin/domain/book/entities/book.dart';
import 'package:htlib_admin/domain/book/validator.dart';
import 'package:htlib_admin/domain/core/value_failures/value_failure.dart';
import 'package:htlib_admin/domain/core/value_objects/value_object.dart';

class BookValueObject extends ValueObject<Book> {
  factory BookValueObject(Book book) {
    return BookValueObject._(validateBookObject(book));
  }

  BookValueObject._(this.value);

  @override
  Either<ValueFailure<Book>, Book> value;
}
