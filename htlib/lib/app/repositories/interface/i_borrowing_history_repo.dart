import 'package:dartz/dartz.dart';
import 'package:htlib/_internal/utils/error_utils.dart';
import 'package:htlib/app/data/borrowing_history.dart';

abstract class IBorrowingHistoryRepo {
  ErrorLog get baseErrLog;

  Future<Either<Error, Unit>> add(BorrowingHistory borrowingHistory);

  Future<Either<Error, Unit>> remove(BorrowingHistory borrowingHistory);

  Future<Either<Error, List<BorrowingHistory>>> getList();

  Stream<List<BorrowingHistory>> get borrowingHistoryStream;
}
