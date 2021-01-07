import 'package:meta/meta.dart';
import 'dart:convert';

class BookCatagory {
  BookCatagory({
    @required this.name,
    @required this.id,
  });

  final String name;
  final String id;

  BookCatagory copyWith({
    String name,
    String id,
  }) =>
      BookCatagory(
        name: name ?? this.name,
        id: id ?? this.id,
      );

  factory BookCatagory.fromRawJson(String str) =>
      BookCatagory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookCatagory.fromJson(Map<String, dynamic> json) => BookCatagory(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
