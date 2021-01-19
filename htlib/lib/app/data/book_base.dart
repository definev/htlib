import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:pluto_grid/pluto_grid.dart';

part 'book_base.g.dart';

@HiveType(typeId: 1)
class BookBase {
  BookBase({
    @required this.id,
    @required this.name,
    @required this.location,
    @required this.year,
    @required this.price,
    @required this.type,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final int year;

  @HiveField(4)
  final int price;

  @HiveField(5)
  final String type;

  @override
  bool operator ==(o) => o is BookBase ? this.id == o.id : false;

  BookBase copyWith({
    int id,
    String name,
    String location,
    int year,
    int price,
    String type,
  }) =>
      BookBase(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
        year: year ?? this.year,
        price: price ?? this.price,
        type: type ?? this.type,
      );

  factory BookBase.fromRawJson(String str) =>
      BookBase.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookBase.fromJson(Map<String, dynamic> json) => BookBase(
        id: json["id"],
        name: json["name"],
        location: json["location"],
        year: json["year"],
        price: json["price"],
        type: json["type"].toString(),
      );

  factory BookBase.fromPlutoRow(PlutoRow json) => BookBase(
        id: json.cells["id"].value,
        name: json.cells["name"].value,
        location: json.cells["location"].value,
        year: json.cells["year"].value,
        price: json.cells["price"].value,
        type: json.cells["type"].value,
      );

  Map<String, PlutoCell> toPlutoCellMap() => {
        "checked": PlutoCell(),
        "id": PlutoCell(value: id),
        "name": PlutoCell(value: name),
        "location": PlutoCell(value: location),
        "year": PlutoCell(value: year),
        "price": PlutoCell(value: price),
        "type": PlutoCell(value: type),
      };

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location,
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
}

Map<String, int> excelBookBase = {
  "id": 1,
  "name": 2,
  "location": 8,
  "year": 9,
  "price": 10,
  "type": 12
};

extension BookBaseExt on List<BookBase> {
  List<PlutoRow> toPlutoRowList() => this
      .map((e) => PlutoRow(
            cells: e.toPlutoCellMap(),
            checked: true,
          ))
      .toList();
}
