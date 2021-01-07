import 'package:htlib_admin/domain/core/value_errors/value_error.dart';

class BookError extends ValueError {
  BookError(String code) : super(code);
}

class BookErrors {
  static BookError cannotFindBook() => BookError("cannot_find_book");
  static BookError emptyBookCategory() => BookError("empty_book_category");
  static BookError emptyField(String fieldName) =>
      BookError("empty_field_$fieldName");
}
