import 'package:htlib_admin/infrastructure/book/local/mock_local_book.dart';
import 'package:injectable/injectable.dart';

@module
abstract class BookInjectableModule {
  @lazySingleton
  LocalBook get localBook => LocalBook();
}
