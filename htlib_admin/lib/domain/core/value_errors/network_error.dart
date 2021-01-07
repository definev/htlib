import 'package:htlib_admin/domain/core/value_errors/value_error.dart';

class NetworkError extends ValueError {
  NetworkError(String code) : super(code);
}
