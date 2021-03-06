// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'user.g.dart';

class UserStatus {
  static const String normal = "Chưa mượn sách";
  static const String rent = "Đang mượn sách";
  static const String warning = "Quá hạn mượn sách";
  static const String banned = "Cấm mượn sách";
}

@HiveType(typeId: 1)
class User {
  static User empty() => User(
        id: "0",
        name: "Nguyễn Văn A",
        idNumberCard: "123456789",
        currentClass: "A6K73",
        phone: "0929623960",
        status: "Đang mượn",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/htlib-adm.appspot.com/o/user%2Fmock.jpg?alt=media&token=7fb36d47-7e97-4ca1-bcd6-98b856705913",
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
    @required this.idNumberCard,
    @required this.name,
    @required this.currentClass,
    @required this.phone,
    @required this.status,
    this.imageUrl,
    @required this.borrowingBookList,
    @required this.borrowedHistoryList,
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String idNumberCard;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String currentClass;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final String imageUrl;

  @HiveField(7)
  final List<String> borrowingBookList;

  @HiveField(8)
  final List<String> borrowedHistoryList;

  User copyWith({
    String id,
    String name,
    String idNumberCard,
    String currentClass,
    String phone,
    String status,
    String imageUrl,
    List<String> borrowingBookList,
    List<String> borrowedHistoryList,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        idNumberCard: idNumberCard ?? this.idNumberCard,
        currentClass: currentClass ?? this.currentClass,
        phone: phone ?? this.phone,
        status: status ?? this.status,
        imageUrl: imageUrl ?? this.imageUrl,
        borrowingBookList: borrowingBookList ?? this.borrowingBookList,
        borrowedHistoryList: borrowedHistoryList ?? this.borrowedHistoryList,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        idNumberCard: json["idNumberCard"],
        currentClass: json["currentClass"],
        phone: json["phone"],
        status: json["status"],
        imageUrl: json["imageUrl"],
        borrowingBookList:
            List<String>.from(json["borrowingBookList"].map((x) => x)),
        borrowedHistoryList:
            List<String>.from(json["borrowedHistoryList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "idNumberCard": idNumberCard,
        "currentClass": currentClass,
        "phone": phone,
        "status": status,
        "imageUrl": imageUrl,
        "borrowingBookList":
            List<dynamic>.from(borrowingBookList.map((x) => x)),
        "borrowedHistoryList":
            List<dynamic>.from(borrowedHistoryList.map((x) => x)),
      };
}
