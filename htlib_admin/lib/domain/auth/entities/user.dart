import 'package:meta/meta.dart';
import 'dart:convert';

class User {
  User({
    @required this.id,
    @required this.username,
    @required this.avatar,
    @required this.token,
  });

  final String id;
  final String username;
  final String avatar;
  final String token;

  User copyWith({
    String id,
    String username,
    String avatar,
    String token,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        avatar: avatar ?? this.avatar,
        token: token ?? this.token,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        avatar: json["avatar"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "avatar": avatar,
        "token": token,
      };
}
