import 'package:htlib/app/data/borrowing_history.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/app/repositories/firebase/core_repo.dart';
import 'package:htlib/app/repositories/interface/i_borrowing_history_repo.dart';

class BorrowingHistoryRepo extends CoreRepo with IBorrowingHistoryRepo {
  BorrowingHistoryRepo() : super(["appData", "BorrowingHistoryRepo"]);

  @override
  Future<Either<Error, Unit>> add(BorrowingHistory borrowingHistory) {}

  @override
  // TODO: implement borrowingHistoryStream
  Stream<List<BorrowingHistory>> get borrowingHistoryStream =>
      throw UnimplementedError();

  @override
  Future<Either<Error, List<BorrowingHistory>>> getList() {}

  @override
  Future<Either<Error, Unit>> remove(BorrowingHistory borrowingHistory) {}
}
