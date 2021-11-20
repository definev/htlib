import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart' as mt;
import 'package:htlib/_internal/utils/color_utils.dart';
import 'package:htlib/src/model/book.dart';
import 'package:pdf/widgets.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final Font font;
  final MemoryImage qrCode;

  BookCard(
    this.book, {
    required this.font,
    required this.qrCode,
  });
  @override
  Widget build(Context context) {
    String nameCode =
        book.name.split(" ").fold("", (p, n) => "$p${n[0]}".toUpperCase());
    if (nameCode.length > 4)
      nameCode = removeDiacritics(nameCode).substring(0, 4);
    try {
      if (!int.parse(book.name.split(" ").last).isNaN) {
        nameCode = nameCode + " " + book.name.split(" ").last;
      }
    } catch (e) {}

    return Container(
      height: 155,
      width: 116,
      decoration: BoxDecoration(
        border: Border.all(color: ColorUtils.toPdfColor(mt.Colors.black)),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("$nameCode", style: TextStyle(font: font, fontSize: 18.0)),
            ],
          ),
          Container(
            height: 1,
            width: 100.0,
            color: ColorUtils.toPdfColor(mt.Colors.black),
          ),
          Image(qrCode),
        ],
      ),
    );
  }
}
