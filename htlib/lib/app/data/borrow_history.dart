// To parse this JSON data, do
//
//     final borrowHistory = borrowHistoryFromJson(jsonString);

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'borrow_history.g.dart';

@HiveType(typeId: 2)
class BorrowHistory {
  BorrowHistory({
    @required this.isbn,
    @required this.createAt,
    @required this.endAt,
    @required this.state,
  });

  @HiveField(0)
  final String isbn;

  @HiveField(1)
  final DateTime createAt;

  @HiveField(2)
  final DateTime endAt;

  @HiveField(3)
  final String state;

  BorrowHistory copyWith({
    String isbn,
    DateTime createAt,
    DateTime endAt,
    String state,
  }) =>
      BorrowHistory(
        isbn: isbn ?? this.isbn,
        createAt: createAt ?? this.createAt,
        endAt: endAt ?? this.endAt,
        state: state ?? this.state,
      );

  factory BorrowHistory.fromRawJson(String str) =>
      BorrowHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BorrowHistory.fromJson(Map<String, dynamic> json) => BorrowHistory(
        isbn: json["isbn"],
        createAt: DateTime.parse(json["createAt"]),
        endAt: DateTime.parse(json["endAt"]),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "createAt": createAt.toIso8601String(),
        "endAt": endAt.toIso8601String(),
        "state": state,
      };
}
