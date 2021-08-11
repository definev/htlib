import 'package:hive/hive.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/hive_id.dart';
import 'dart:convert';
import 'package:get/get.dart';

part 'renting_history.g.dart';

enum RentingHistoryStateCode { renting, warning, expired, returned }

RentingHistoryStateCode getStateCode(RentingHistory e, DateTime now, HtlibDb db) {
  if (e.state == RentingHistoryStateCode.returned.index) {
    return RentingHistoryStateCode.returned;
  } else if (e.endAt.isBefore(now)) {
    return RentingHistoryStateCode.expired;
  } else {
    if (e.endAt.difference(now) <= db.config.warningDay.days) {
      return RentingHistoryStateCode.warning;
    } else {
      return RentingHistoryStateCode.renting;
    }
  }
}

List<String> rentingHistoryStateCode = RentingHistoryStateCode.values.map((e) {
  switch (e) {
    case RentingHistoryStateCode.renting:
      return "Đang mượn";
    case RentingHistoryStateCode.warning:
      return "Sắp đến hạn trả";
    case RentingHistoryStateCode.expired:
      return "Quá hạn trả";
    case RentingHistoryStateCode.returned:
      return "Đã trả";
    default:
      return "Đã trả";
  }
}).toList();

@HiveType(typeId: HiveId.rentingHistory)
class RentingHistory {
  RentingHistory({
    required this.id,
    required this.borrowBy,
    required this.bookMap,
    required this.createAt,
    required this.endAt,
    required this.state,
    required this.total,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String borrowBy;
  @HiveField(2)
  final Map<String, int> bookMap;
  @HiveField(3)
  final DateTime createAt;
  @HiveField(4)
  final DateTime endAt;
  @HiveField(5)
  final int state;
  @HiveField(6)
  final int total;

  RentingHistory copyWith({
    String? id,
    String? borrowBy,
    Map<String, int>? bookMap,
    DateTime? createAt,
    DateTime? endAt,
    int? state,
    int? total,
  }) =>
      RentingHistory(
        id: id ?? this.id,
        borrowBy: borrowBy ?? this.borrowBy,
        bookMap: bookMap ?? this.bookMap,
        createAt: createAt ?? this.createAt,
        endAt: endAt ?? this.endAt,
        state: state ?? this.state,
        total: total ?? this.total,
      );

  factory RentingHistory.fromRawJson(String str) => RentingHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RentingHistory.fromJson(Map<String, dynamic> json) => RentingHistory(
        id: json["id"],
        borrowBy: json["borrowBy"],
        bookMap: Map<String, int>.from(json["bookMap"]),
        createAt: DateTime.parse(json["createAt"]),
        endAt: DateTime.parse(json["endAt"]),
        state: json["state"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "borrowBy": borrowBy,
        "bookMap": bookMap,
        "createAt": createAt.toIso8601String(),
        "endAt": endAt.toIso8601String(),
        "state": state,
        "total": total,
      };

  @override
  operator ==(Object o) => (o is RentingHistory) ? o.id == this.id : false;
}
