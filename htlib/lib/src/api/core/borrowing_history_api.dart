import 'package:dartz/dartz.dart';
import 'package:htlib/src/model/borrowing_history.dart';

abstract class BorrowingHistoryApi {
  Future<Either<Error, Unit>> add(BorrowingHistory borrowingHistory);

  Future<Either<Error, Unit>> remove(BorrowingHistory borrowingHistory);

  Future<Either<Error, List<BorrowingHistory>>> getList();

  Stream<List<BorrowingHistory>> get borrowingHistoryStream;
}
