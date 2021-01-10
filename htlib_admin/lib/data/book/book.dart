import 'dart:convert';
import 'package:htlib_admin/data/.core/adapter_utils.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

part "book.g.dart";

@HiveType(typeId: AdapterUtils.book)
class Book {
  Book({
    @required this.id,
    @required this.title,
    @required this.desc,
    @required this.total,
    @required this.remain,
    @required this.rates,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String desc;
  @HiveField(3)
  final int total;
  @HiveField(4)
  final int remain;
  @HiveField(5)
  final double rates;

  Book copyWith({
    String id,
    String title,
    String desc,
    int total,
    int remain,
    double rates,
  }) =>
      Book(
        id: id ?? this.id,
        title: title ?? this.title,
        desc: desc ?? this.desc,
        total: total ?? this.total,
        remain: remain ?? this.remain,
        rates: rates ?? this.rates,
      );

  factory Book.fromRawJson(String str) => Book.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        desc: json["desc"],
        total: json["total"],
        remain: json["remain"],
        rates: json["rates"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "desc": desc,
        "total": total,
        "remain": remain,
        "rates": rates,
      };
}
