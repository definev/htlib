// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  static User empty() => User(
        id: "",
        name: "",
        currentClass: "",
        phone: "",
        status: "",
        image: "",
        borrowingBookList: [],
        borrowedHistoryList: [],
      );

  static bool isEmpty(User user) => user == empty();

  @override
  operator ==(Object o) {
    if (o is User) return o.id == this.id;
    return false;
  }

  User({
    @required this.id,
    @required this.name,
    @required this.currentClass,
    @required this.phone,
    @required this.status,
    @required this.image,
    @required this.borrowingBookList,
    @required this.borrowedHistoryList,
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String currentClass;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final String image;

  @HiveField(6)
  final List<String> borrowingBookList;

  @HiveField(7)
  final List<String> borrowedHistoryList;

  User copyWith({
    String id,
    String name,
    String currentClass,
    String phone,
    String status,
    String image,
    List<String> borrowingBookList,
    List<String> borrowedHistoryList,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        currentClass: currentClass ?? this.currentClass,
        phone: phone ?? this.phone,
        status: status ?? this.status,
        image: image ?? this.image,
        borrowingBookList: borrowingBookList ?? this.borrowingBookList,
        borrowedHistoryList: borrowedHistoryList ?? this.borrowedHistoryList,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        currentClass: json["currentClass"],
        phone: json["phone"],
        status: json["status"],
        image: json["image"],
        borrowingBookList:
            List<String>.from(json["borrowingBookList"].map((x) => x)),
        borrowedHistoryList:
            List<String>.from(json["borrowedHistoryList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "currentClass": currentClass,
        "phone": phone,
        "status": status,
        "image": image,
        "borrowingBookList":
            List<dynamic>.from(borrowingBookList.map((x) => x)),
        "borrowedHistoryList":
            List<dynamic>.from(borrowedHistoryList.map((x) => x)),
      };
}
