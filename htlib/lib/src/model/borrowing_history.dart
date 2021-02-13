// To parse this JSON data, do
//
//     final borrowingHistory = borrowHistoryFromJson(jsonString);

import 'package:hive/hive.dart';
import 'dart:convert';

part 'borrowing_history.g.dart';

@HiveType(typeId: 2)
class BorrowingHistory {
  BorrowingHistory({
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
  final String state;

  BorrowingHistory copyWith({
    String id,
    String borrowBy,
    List<String> isbnList,
    DateTime createAt,
    DateTime endAt,
    String state,
  }) =>
      BorrowingHistory(
        id: id ?? this.id,
        borrowBy: borrowBy ?? this.borrowBy,
        isbnList: isbnList ?? this.isbnList,
        createAt: createAt ?? this.createAt,
        endAt: endAt ?? this.endAt,
        state: state ?? this.state,
      );

  factory BorrowingHistory.fromRawJson(String str) =>
      BorrowingHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BorrowingHistory.fromJson(Map<String, dynamic> json) =>
      BorrowingHistory(
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
}
