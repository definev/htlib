// To parse this JSON data, do
//
//     final rentingHistory = borrowHistoryFromJson(jsonString);

import 'dart:math';

import 'package:hive/hive.dart';
import 'package:htlib/src/model/hive_id.dart';
import 'dart:convert';

import 'package:htlib/src/model/user.dart';

part 'renting_history.g.dart';

enum RentingHistoryStateCode { renting, warning, expired, returned }

@HiveType(typeId: HiveId.rentingHistory)
class RentingHistory {
  RentingHistory({
    this.id,
    this.borrowBy,
    this.isbnList,
    this.createAt,
    this.endAt,
    this.state,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String borrowBy;
  @HiveField(2)
  final List<String> isbnList;
  @HiveField(3)
  final DateTime createAt;
  @HiveField(4)
  final DateTime endAt;
  @HiveField(5)
  final int state;

  RentingHistory copyWith({
    String id,
    String borrowBy,
    List<String> isbnList,
    DateTime createAt,
    DateTime endAt,
    int state,
  }) =>
      RentingHistory(
        id: id ?? this.id,
        borrowBy: borrowBy ?? this.borrowBy,
        isbnList: isbnList ?? this.isbnList,
        createAt: createAt ?? this.createAt,
        endAt: endAt ?? this.endAt,
        state: state ?? this.state,
      );

  factory RentingHistory.fromRawJson(String str) =>
      RentingHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RentingHistory.fromJson(Map<String, dynamic> json) => RentingHistory(
        id: json["id"],
        borrowBy: json["borrowBy"],
        isbnList: List<String>.from(json["isbnList"].map((x) => x)),
        createAt: DateTime.parse(json["createAt"]),
        endAt: DateTime.parse(json["endAt"]),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "borrowBy": borrowBy,
        "isbnList": List<dynamic>.from(isbnList.map((x) => x)),
        "createAt": createAt.toIso8601String(),
        "endAt": endAt.toIso8601String(),
        "state": state,
      };

  static RentingHistory random() {
    Random random = Random();
    return RentingHistory.fromJson({
      "id": (1000000 + random.nextInt(10000000)).toString(),
      "borrowBy": User.empty().id,
      "isbnList": [
        random.nextInt(10000000).toString(),
        random.nextInt(10000000).toString()
      ],
      "createAt": "2020-01-22T16:53:23+00:00",
      "endAt": DateTime.now()
          .add(Duration(days: -4 + random.nextInt(12)))
          .toString(),
      "state": random.nextInt(4),
    });
  }

  @override
  operator ==(Object o) => (o is RentingHistory) ? o.id == this.id : false;
}
