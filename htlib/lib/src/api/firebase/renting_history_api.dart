import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htlib/_internal/utils/error_utils.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';

import 'core/err/firebase_error.dart';

class RentingHistoryApi extends FirebaseCoreApi with CRUDApi<RentingHistory> {
  RentingHistoryApi() : super(["appData", "RentingHistoryApi"]);

  ErrorLog get baseErrLog => ErrorLog(from: "RentingHistoryApi");

  @override
  Future<void> add(RentingHistory rentingHistory) async {
    var dataBucket = (getData(["RentingHistory"]) as Left).value;

    await dataBucket.doc(rentingHistory.id).set(rentingHistory.toJson());
  }

  @override
  Future<void> addList(List<RentingHistory> dataList) async {
    await dataList.forEach((bh) async => await add(bh));
  }

  @override
  Stream<List<RentingHistory>> get stream {
    var dataBucket = (getData(["RentingHistory"]) as Left).value;

    return dataBucket.snapshots().map(
          (sns) => sns == null
              ? []
              : sns.docs
                  .map((doc) => RentingHistory.fromJson(doc.data()))
                  .toList(),
        );
  }

  @override
  Future<List<RentingHistory>> getList() async {
    var dataBucket = (getData(["RentingHistory"]) as Left).value;

    var sns = await dataBucket.get();
    var data =
        sns.docs.map((doc) => RentingHistory.fromJson(doc.data())).toList();

    return data;
  }

  @override
  Future<Either<Error, Unit>> remove(RentingHistory rentingHistory) {
    var dataBucket = getData(["RentingHistory", "${rentingHistory.id}"]);
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
  Future<RentingHistory> getDataById(String id) async {
    var dataBucket = (getData(["RentingHistory", "$id"]) as Right).value;
    DocumentSnapshot doc = await dataBucket.get();
    if (doc.data() != null) {
      var res = RentingHistory.fromJson(Map<String, dynamic>.from(doc.data()));
      return res;
    }
    return null;
  }
}