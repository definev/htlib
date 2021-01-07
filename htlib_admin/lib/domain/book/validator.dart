import 'package:dartz/dartz.dart';
import 'package:htlib_admin/domain/book/entities/book.dart';
import 'package:htlib_admin/domain/core/value_failures/value_failure.dart';

Either<ValueFailure<Book>, Book> validateBookObject(Book value) => right(value);
