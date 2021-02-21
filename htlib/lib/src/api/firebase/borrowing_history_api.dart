import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htlib/_internal/utils/error_utils.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/borrowing_history.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';

import 'core/err/firebase_error.dart';

class BorrowingHistoryApi extends FirebaseCoreApi
    with CRUDApi<BorrowingHistory> {
  BorrowingHistoryApi() : super(["appData", "BorrowingHistoryApi"]);

  ErrorLog get baseErrLog => ErrorLog(from: "BorrowingHistoryApi");

  @override
  Future<void> add(BorrowingHistory borrowingHistory) async {
    var dataBucket = (getData(["BorrowingHistory"]) as Left).value;

    await dataBucket.doc(borrowingHistory.id).set(borrowingHistory.toJson());
  }

  @override
  Future<void> addList(List<BorrowingHistory> dataList) async {
    await dataList.forEach((bh) async => await add(bh));
  }

  @override
  Stream<List<BorrowingHistory>> get stream {
    var dataBucket = (getData(["BorrowingHistory"]) as Left).value;

    return dataBucket.snapshots().map(
          (sns) => sns == null
              ? []
              : sns.docs
                  .map((doc) => BorrowingHistory.fromJson(doc.data()))
                  .toList(),
        );
  }

  @override
  Future<List<BorrowingHistory>> getList() async {
    var dataBucket = (getData(["BorrowingHistory"]) as Left).value;

    var sns = await dataBucket.get();
    var data =
        sns.docs.map((doc) => BorrowingHistory.fromJson(doc.data())).toList();

    return data;
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

  @override
  Future<BorrowingHistory> getDataById(String id) async {
    var dataBucket = (getData(["BorrowingHistory", "$id"]) as Right).value;
    DocumentSnapshot doc = await dataBucket.get();
    if (doc.data() != null) {
      var res =
          BorrowingHistory.fromJson(Map<String, dynamic>.from(doc.data()));
      return res;
    }
    return null;
  }
}
