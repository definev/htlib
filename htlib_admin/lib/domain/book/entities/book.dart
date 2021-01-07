import 'package:htlib_admin/domain/book/entities/book_catagory.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class Book {
  Book({
    @required this.id,
    @required this.title,
    @required this.author,
    @required this.lang,
    @required this.desc,
    @required this.coverImg,
    @required this.imgList,
    @required this.bookCatagoryList,
    @required this.pages,
    @required this.rates,
  });

  final String id;
  final String title;
  final String author;
  final String desc;
  final String lang;
  final String coverImg;
  final List<String> imgList;
  final List<BookCatagory> bookCatagoryList;
  final int pages;
  final double rates;

  Book copyWith({
    String id,
    String title,
    String author,
    String desc,
    String lang,
    String coverImg,
    List<String> imgList,
    List<BookCatagory> bookCatagoryList,
    int pages,
    double rates,
  }) =>
      Book(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author ?? this.author,
        desc: desc ?? this.desc,
        lang: lang ?? this.lang,
        coverImg: coverImg ?? this.coverImg,
        imgList: imgList ?? this.imgList,
        bookCatagoryList: bookCatagoryList ?? this.bookCatagoryList,
        pages: pages ?? this.pages,
        rates: rates ?? this.rates,
      );

  factory Book.fromRawJson(String str) => Book.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        desc: json["desc"],
        lang: json["lang"],
        coverImg: json["coverImg"],
        imgList: List<String>.from(json["imgList"].map((x) => x)),
        bookCatagoryList: List<BookCatagory>.from(
          json["bookCatagoryList"].map((x) => BookCatagory.fromJson(x)),
        ),
        pages: json["pages"],
        rates: json["rates"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "desc": desc,
        "lang": lang,
        "coverImg": coverImg,
        "imgList": List<dynamic>.from(imgList.map((x) => x)),
        "bookCatagoryList": List<BookCatagory>.from(
          bookCatagoryList.map((x) => x.toJson()),
        ),
        "pages": pages,
        "rates": rates,
      };
}
