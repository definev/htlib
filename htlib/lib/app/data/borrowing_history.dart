// To parse this JSON data, do
//
//     final borrowingHistory = borrowHistoryFromJson(jsonString);

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'borrowing_history.g.dart';

@HiveType(typeId: 2)
class BorrowingHistory {
  BorrowingHistory({
    @required this.id,
    @required this.isbn,
    @required this.createAt,
    @required this.endAt,
    @required this.state,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String isbn;

  @HiveField(2)
  final DateTime createAt;

  @HiveField(3)
  final DateTime endAt;

  @HiveField(4)
  final String state;

  BorrowingHistory copyWith({
    String id,
    String isbn,
    DateTime createAt,
    DateTime endAt,
    String state,
  }) =>
      BorrowingHistory(
        id: id ?? this.id,
        isbn: isbn ?? this.isbn,
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
        isbn: json["isbn"],
        createAt: DateTime.parse(json["createAt"]),
        endAt: DateTime.parse(json["endAt"]),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isbn": isbn,
        "createAt": createAt.toIso8601String(),
        "endAt": endAt.toIso8601String(),
        "state": state,
      };
}
