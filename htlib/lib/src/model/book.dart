import 'package:hive/hive.dart';
import 'package:htlib/src/model/hive_id.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:uuid/uuid.dart';

part 'book.g.dart';

@HiveType(typeId: HiveId.book)
class Book {
  Book({
    this.id,
    @required this.isbn,
    @required this.name,
    @required this.publisher,
    @required this.year,
    @required this.price,
    @required this.type,
    @required this.quantity,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String isbn;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String publisher;

  @HiveField(4)
  final int year;

  @HiveField(5)
  final int price;

  @HiveField(6)
  final List<String> type;

  @HiveField(7)
  final int quantity;

  @override
  bool operator ==(o) => o is Book ? this.id == o.id : false;

  Book copyWith({
    String isbn,
    String name,
    String publisher,
    int year,
    int price,
    List<String> type,
    int quantity,
  }) =>
      Book(
        isbn: isbn ?? this.isbn,
        name: name ?? this.name,
        publisher: publisher ?? this.publisher,
        year: year ?? this.year,
        price: price ?? this.price,
        type: type ?? this.type,
        quantity: quantity ?? this.quantity,
      );

  factory Book.fromRawJson(String str) => Book.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"].toString(),
        isbn: json["isbn"].toString(),
        name: json["name"].toString(),
        publisher: json["publisher"].toString(),
        year: json["year"],
        price: json["price"],
        type: List<String>.from(json["type"].map((e) => e)),
        quantity: json["quantity"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isbn": isbn,
        "name": name,
        "publisher": publisher,
        "year": year,
        "price": price,
        "type": type,
        "quantity": quantity,
      };

  factory Book.fromExcelRow(List<dynamic> row) {
    Map<String, dynamic> json = {};
    json["id"] = Uuid().v4();
    json["quantity"] = 0;
    excelBook.forEach((key, value) {
      if (key == "type")
        json[key] = [row[value].toString()];
      else
        json[key] = row[value];
    });

    return Book.fromJson(json);
  }

  String typeToSafeString() {
    String res = "";
    for (int i = 0; i < type.length; i++) {
      res = res + type[i] + (i == type.length - 1 ? "" : ", ");
    }

    return res;
  }
}

Map<String, int> excelBook = {
  "isbn": 1,
  "name": 2,
  "publisher": 8,
  "year": 9,
  "price": 10,
  "type": 12
};
