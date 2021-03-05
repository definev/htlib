import 'package:hive/hive.dart';
import 'package:htlib/src/model/hive_id.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'book.g.dart';

@HiveType(typeId: HiveId.book)
class Book {
  Book({
    @required this.isbn,
    @required this.name,
    @required this.publisher,
    @required this.year,
    @required this.price,
    @required this.type,
    @required this.quantity,
  });

  @HiveField(0)
  final String isbn;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String publisher;

  @HiveField(3)
  final int year;

  @HiveField(4)
  final int price;

  @HiveField(5)
  final String type;

  @HiveField(6)
  final int quantity;

  @override
  bool operator ==(o) => o is Book ? this.isbn == o.isbn : false;

  Book copyWith({
    int isbn,
    String name,
    String publisher,
    int year,
    int price,
    String type,
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
        isbn: json["isbn"].toString(),
        name: json["name"].toString(),
        publisher: json["publisher"].toString(),
        year: json["year"],
        price: json["price"],
        type: json["type"].toString(),
        quantity: json["quantity"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
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
    excelBook.forEach((key, value) {
      json[key] = row[value];
    });
    json["quantity"] = 0;
    return Book.fromJson(json);
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
