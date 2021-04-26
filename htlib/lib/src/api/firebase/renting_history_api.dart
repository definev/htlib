import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htlib/mode/mode.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/src/api/firebase/core/firebase_core_api.dart';

class RentingHistoryApi extends FirebaseCoreApi with CRUDApi<RentingHistory> {
  RentingHistoryApi() : super(["${MODE}AppData", "${MODE}RentingHistoryApi"]);

  @override
  Future<void> add(RentingHistory rentingHistory) async {
    if (!isContinue()) return;
    var dataBucket = (getData(["RentingHistory"])
            as Left<CollectionReference?, DocumentReference?>)
        .value!;

    await dataBucket.doc(rentingHistory.id).set(rentingHistory.toJson());
  }

  @override
  Future<void> edit(RentingHistory? rentingHistory) async {
    if (!isContinue()) return;
    var dataBucket = (getData(["RentingHistory"])
            as Left<CollectionReference?, DocumentReference?>)
        .value!;

    await dataBucket
        .doc("${rentingHistory!.id}")
        .set(rentingHistory.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> addList(List<RentingHistory> dataList) async {
    if (!isContinue()) return;
    dataList.forEach((bh) async => await add(bh));
  }

  @override
  Stream<List<RentingHistory>> get stream {
    var dataBucket = (getData(["RentingHistory"])
            as Left<CollectionReference?, DocumentReference?>)
        .value!;

    return dataBucket.snapshots().map(
          // ignore: unnecessary_null_comparison
          (sns) => sns == null
              ? []
              : sns.docs
                  .map((doc) => RentingHistory.fromJson(doc.data()))
                  .toList(),
        );
  }

  @override
  Future<List<RentingHistory>> getList() async {
    if (!isContinue()) return [];
    var dataBucket = (getData(["RentingHistory"])
            as Left<CollectionReference?, DocumentReference?>)
        .value!;

    QuerySnapshot q = await dataBucket.get();
    List<RentingHistory> data = q.docs
        .map<RentingHistory>((doc) => RentingHistory.fromJson(doc.data()))
        .toList();

    return data;
  }

  @override
  Future<void> remove(RentingHistory rentingHistory) async {
    if (!isContinue()) return;

    var dataBucket = (getData(["RentingHistory", "${rentingHistory.id}"])
            as Right<CollectionReference?, DocumentReference?>)
        .value!;
    await dataBucket.delete();
  }

  @override
  Future<RentingHistory?> getDataById(String id) async {
    if (!isContinue()) return RentingHistory.random();

    var dataBucket = (getData(["RentingHistory", "$id"])
            as Right<CollectionReference?, DocumentReference?>)
        .value!;
    DocumentSnapshot doc = await dataBucket.get();
    if (doc.data() != null) {
      var res = RentingHistory.fromJson(Map<String, dynamic>.from(doc.data()!));
      return res;
    }
    return null;
  }
}
