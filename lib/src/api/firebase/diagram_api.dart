import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:htlib/mode/mode.dart';
import 'package:htlib/src/api/core/crud_api.dart';
import 'package:htlib/src/model/diagram_node.dart';

import 'core/firebase_core_api.dart';

class FirebaseDiagramApi extends FirebaseCoreApi
    implements CRUDApi<DiagramNode> {
  FirebaseDiagramApi() : super(["${MODE}AppData", "${MODE}DiagramApi"]);

  @override
  Future<void> add(DiagramNode data) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["Diagram"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;

    await dataBucket.doc("${data.id}").set(
          data.toJson(),
          SetOptions(merge: false),
        );
  }

  @override
  Future<void> addList(List<DiagramNode> dataList) async {
    if (!isContinue()) return;
    dataList.forEach((book) async => await add(book));
  }

  @override
  Future<void> edit(DiagramNode data) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["Diagram"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;

    await dataBucket
        .doc("${data.id}")
        .set(data.toJson(), SetOptions(merge: true));
  }

  @override
  Future<DiagramNode?> getDataById(String id) async {
    var dataBucket = (getData(["Diagram", "$id"])
            as Right<CollectionReference?, DocumentReference?>)
        .value!;
    DocumentSnapshot doc = await dataBucket.get();
    if (doc.data() != null) {
      var res = DiagramNode.fromJson(Map<String, dynamic>.from(doc.data()!));
      return res;
    }
    return null;
  }

  @override
  Future<List<DiagramNode>> getList() async {
    if (!isContinue()) return [];
    var dataBucket =
        (getData(["Diagram"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;
    QuerySnapshot snapshot = await dataBucket.get();
    List<DiagramNode> res = snapshot.docs
        .map<DiagramNode>((e) => DiagramNode.fromJson(e.data()))
        .toList();

    return res;
  }

  @override
  Future<void> remove(DiagramNode data) async {
    if (!isContinue()) return;
    var dataBucket =
        (getData(["Diagram"]) as Left<CollectionReference?, DocumentReference?>)
            .value!;
    await dataBucket.doc("${data.id}").delete();
  }

  @override
  Stream<List<DiagramNode>> get stream =>
      throw Error.safeToString("Unimplement bookList");
}
