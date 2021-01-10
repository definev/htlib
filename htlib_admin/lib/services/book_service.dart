import 'package:hive/hive.dart';
import 'package:htlib_admin/data/book/book.dart';
import 'package:htlib_admin/services/.core/base_service.dart';

class BookService extends BaseService<Book> {
  static BookService _instance;
  static BookService get instance {
    _instance ??= BookService._();
    return _instance;
  }

  BookService._() : super("bookService") {
    Hive.registerAdapter(BookAdapter());
  }

  List<Book> get bookList => hBox.values.toList();

  void addBook(Book book) => write("${book.id}", book);

  void deleteBook(Book book) => delete("${book.id}");

  void editBook(Book book) => write("${book.id}", book);
}
