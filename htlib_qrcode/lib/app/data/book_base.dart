import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'book_base.g.dart';

@HiveType(typeId: 1)
class BookBase {
  BookBase({
    @required this.isbn,
    @required this.name,
    @required this.publisher,
    @required this.year,
    @required this.price,
    @required this.type,
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

  @override
  bool operator ==(o) => o is BookBase ? this.isbn == o.isbn : false;

  BookBase copyWith({
    int isbn,
    String name,
    String publisher,
    int year,
    int price,
    String type,
  }) =>
      BookBase(
        isbn: isbn ?? this.isbn,
        name: name ?? this.name,
        publisher: publisher ?? this.publisher,
        year: year ?? this.year,
        price: price ?? this.price,
        type: type ?? this.type,
      );

  factory BookBase.fromRawJson(String str) =>
      BookBase.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookBase.fromJson(Map<String, dynamic> json) => BookBase(
        isbn: json["isbn"].toString(),
        name: json["name"].toString(),
        publisher: json["publisher"].toString(),
        year: json["year"],
        price: json["price"],
        type: json["type"].toString(),
      );

  // factory BookBase.fromPlutoRow(PlutoRow json) => BookBase(
  //       isbn: json.cells["isbn"].value,
  //       name: json.cells["name"].value,
  //       publisher: json.cells["publisher"].value,
  //       year: json.cells["year"].value,
  //       price: json.cells["price"].value,
  //       type: json.cells["type"].value,
  //     );

  // Map<String, PlutoCell> toPlutoCellMap() => {
  //       "checked": PlutoCell(),
  //       "isbn": PlutoCell(value: isbn),
  //       "name": PlutoCell(value: name),
  //       "publisher": PlutoCell(value: publisher),
  //       "year": PlutoCell(value: year),
  //       "price": PlutoCell(value: price),
  //       "type": PlutoCell(value: type),
  //     };

  Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "name": name,
        "publisher": publisher,
        "year": year,
        "price": price,
        "type": type,
      };

  factory BookBase.fromExcelRow(List<dynamic> row) {
    Map<String, dynamic> json = {};
    excelBookBase.forEach((key, value) {
      json[key] = row[value];
    });
    return BookBase.fromJson(json);
  }

  @override
  int get hashCode => super.hashCode;
}

Map<String, int> excelBookBase = {
  "isbn": 1,
  "name": 2,
  "publisher": 8,
  "year": 9,
  "price": 10,
  "type": 12
};
