import 'dart:math';

import 'package:hive/hive.dart';
import 'package:htlib/src/model/hive_id.dart';
import 'dart:convert';

import 'package:htlib/src/model/user.dart';

part 'renting_history.g.dart';

enum RentingHistoryStateCode { renting, warning, expired, returned }

List<String> rentingHistoryStateCode = RentingHistoryStateCode.values.map((e) {
  switch (e) {
    case RentingHistoryStateCode.renting:
      return "Đang mượn";
      break;
    case RentingHistoryStateCode.warning:
      return "Sắp đến hạn trả";
      break;
    case RentingHistoryStateCode.expired:
      return "Quá hạn trả";
      break;
    case RentingHistoryStateCode.returned:
      return "Đã trả";
      break;
    default:
      return "Đã trả";
  }
}).toList();

@HiveType(typeId: HiveId.rentingHistory)
class RentingHistory {
  RentingHistory({
    this.id,
    this.borrowBy,
    this.bookList,
    this.createAt,
    this.endAt,
    this.state,
    this.total,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String borrowBy;
  @HiveField(2)
  final List<String> bookList;
  @HiveField(3)
  final DateTime createAt;
  @HiveField(4)
  final DateTime endAt;
  @HiveField(5)
  final int state;
  @HiveField(6)
  final int total;

  RentingHistory copyWith({
    String id,
    String borrowBy,
    List<String> bookList,
    DateTime createAt,
    DateTime endAt,
    int state,
    int total,
  }) =>
      RentingHistory(
        id: id ?? this.id,
        borrowBy: borrowBy ?? this.borrowBy,
        bookList: bookList ?? this.bookList,
        createAt: createAt ?? this.createAt,
        endAt: endAt ?? this.endAt,
        state: state ?? this.state,
        total: total ?? this.total,
      );

  factory RentingHistory.fromRawJson(String str) =>
      RentingHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RentingHistory.fromJson(Map<String, dynamic> json) => RentingHistory(
        id: json["id"],
        borrowBy: json["borrowBy"],
        bookList: List<String>.from(json["bookList"].map((x) => x)),
        createAt: DateTime.parse(json["createAt"]),
        endAt: DateTime.parse(json["endAt"]),
        state: json["state"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "borrowBy": borrowBy,
        "bookList": List<dynamic>.from(bookList.map((x) => x)),
        "createAt": createAt.toIso8601String(),
        "endAt": endAt.toIso8601String(),
        "state": state,
        "total": total,
      };

  static RentingHistory random() {
    Random random = Random();
    return RentingHistory.fromJson({
      "id": (1000000 + random.nextInt(10000000)).toString(),
      "borrowBy": random.nextInt(2) == 0 ? User.userA().id : User.userB().id,
      "bookList": [
        random.nextInt(10000000).toString(),
        random.nextInt(10000000).toString()
      ],
      "createAt": "2020-01-22T16:53:23+00:00",
      "endAt": DateTime.now()
          .add(Duration(days: -4 + random.nextInt(12)))
          .toString(),
      "state": random.nextInt(4),
      "total": 1000000,
    });
  }

  @override
  operator ==(Object o) => (o is RentingHistory) ? o.id == this.id : false;
}
