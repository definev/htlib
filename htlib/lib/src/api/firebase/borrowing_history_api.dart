import 'package:htlib/_internal/utils/error_utils.dart';
import 'package:htlib/src/api/core/borrowing_history_api.dart';
import 'package:htlib/src/model/borrowing_history.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';

import 'core/err/firebase_error.dart';

class BorrowingHistoryRepo extends FirebaseCoreApi with BorrowingHistoryApi {
  BorrowingHistoryRepo() : super(["appData", "BorrowingHistoryRepo"]);

  ErrorLog get baseErrLog => ErrorLog(from: "BorrowingHistoryRepo");

  @override
  Future<Either<Error, Unit>> add(BorrowingHistory borrowingHistory) async {
    var dataBucket = getData(["borrowingHistory"]);
    return dataBucket.fold(
      (l) async => await ErrorUtils.errorCatch(
        () async {
          await l.doc(borrowingHistory.id).set(borrowingHistory.toJson());
          return right(unit);
        },
        onError: () async => left(NetworkError()),
        errorLog: baseErrLog.copyWith(from: "Add"),
      ),
      (r) => null,
    );
  }

  @override
  Stream<List<BorrowingHistory>> get borrowingHistoryStream =>
      getData(["BorrowingHistory"]).fold(
          (l) => l.snapshots().map(
                (sns) => sns == null
                    ? []
                    : sns.docs
                        .map((doc) => BorrowingHistory.fromJson(doc.data()))
                        .toList(),
              ),
          (r) => null);

  @override
  Future<Either<Error, List<BorrowingHistory>>> getList() async {
    var dataBucket = getData(["BorrowingHistory"]);

    return dataBucket.fold(
      (l) async => await ErrorUtils.errorCatch(
        () async {
          var sns = await l.get();
          var data = sns.docs
              .map((doc) => BorrowingHistory.fromJson(doc.data()))
              .toList();

          return right(data);
        },
        onError: () async => left(NetworkError()),
        errorLog: baseErrLog.copyWith(from: "getList"),
      ),
      (r) => null,
    );
  }

  @override
  Future<Either<Error, Unit>> remove(BorrowingHistory borrowingHistory) {
    var dataBucket = getData(["BorrowingHistory", "${borrowingHistory.id}"]);
    return dataBucket.fold(
        (l) => null,
        (r) async => await ErrorUtils.errorCatch(
              () async {
                await r.delete();
                return right(unit);
              },
              onError: () async => left(NetworkError()),
              errorLog: baseErrLog.copyWith(from: "remove"),
            ));
  }
}
