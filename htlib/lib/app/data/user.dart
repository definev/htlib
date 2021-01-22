// To parse this JSON data, do
//
//     final bookBase = bookBaseFromJson(jsonString);

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  User({
    @required this.id,
    @required this.name,
    @required this.bookBaseClass,
    @required this.phone,
    @required this.status,
    @required this.borrowBookList,
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String bookBaseClass;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final List<String> borrowBookList;

  User copyWith({
    String id,
    String name,
    String bookBaseClass,
    String phone,
    String status,
    List<String> borrowBookList,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        bookBaseClass: bookBaseClass ?? this.bookBaseClass,
        phone: phone ?? this.phone,
        status: status ?? this.status,
        borrowBookList: borrowBookList ?? this.borrowBookList,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        bookBaseClass: json["class"],
        phone: json["phone"],
        status: json["status"],
        borrowBookList: List<String>.from(json["borrowBookList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "class": bookBaseClass,
        "phone": phone,
        "status": status,
        "borrowBookList": List<dynamic>.from(borrowBookList.map((x) => x)),
      };
}
