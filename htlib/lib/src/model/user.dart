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

@HiveType(typeId: 2)
class User {
  static User userA() => User(
        id: "0",
        name: "Nguyễn Văn B",
        idNumberCard: "124124124124",
        currentClass: "A6-K73",
        phone: "0929623960",
        status: "Đang mượn",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/htlib-adm.appspot.com/o/user%2Fmock.jpg?alt=media&token=9126331e-efea-4503-b197-9aefe32f9075",
        bookMap: {},
        rentingHistoryList: [],
      );
  static User userB() => User(
        id: "1",
        name: "Nguyễn Văn A",
        idNumberCard: "9965645645222",
        currentClass: "A8-K74",
        phone: "0929623960",
        status: "Đang mượn",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/htlib-adm.appspot.com/o/user%2Fmock.jpg?alt=media&token=9126331e-efea-4503-b197-9aefe32f9075",
        bookMap: {},
        rentingHistoryList: [],
      );

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
    @required this.bookMap,
    @required this.rentingHistoryList,
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
  final Map<String, int> bookMap;

  @HiveField(8)
  final List<String> rentingHistoryList;

  User copyWith({
    String id,
    String name,
    String idNumberCard,
    String currentClass,
    String phone,
    String status,
    String imageUrl,
    Map<String, int> bookMap,
    List<String> rentingHistoryList,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        idNumberCard: idNumberCard ?? this.idNumberCard,
        currentClass: currentClass ?? this.currentClass,
        phone: phone ?? this.phone,
        status: status ?? this.status,
        imageUrl: imageUrl ?? this.imageUrl,
        bookMap: bookMap ?? this.bookMap,
        rentingHistoryList: rentingHistoryList ?? this.rentingHistoryList,
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
        bookMap: json["bookMap"],
        rentingHistoryList:
            List<String>.from(json["rentingHistoryList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "idNumberCard": idNumberCard,
        "currentClass": currentClass,
        "phone": phone,
        "status": status,
        "imageUrl": imageUrl,
        "bookMap": bookMap,
        "rentingHistoryList":
            List<dynamic>.from(rentingHistoryList.map((x) => x)),
      };
}
