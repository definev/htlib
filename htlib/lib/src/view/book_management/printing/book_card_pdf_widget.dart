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
    this.font,
    this.qrCode,
  });
  @override
  Widget build(Context context) {
    String nameCode =
        book.name.split(" ").fold("", (p, n) => "$p${n[0]}".toUpperCase());
    if (nameCode.length > 3) nameCode = nameCode.substring(0, 3);
    String type = book.typeToSafeString();
    if (type.length > 6) type = type.substring(0, 6);

    return Container(
      height: 560 / 6,
      width: 800 / 6,
      decoration: BoxDecoration(
        border: Border.all(color: ColorUtils.toPdfColor(mt.Colors.black)),
      ),
      margin: EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$nameCode",
                style: TextStyle(font: font, fontSize: 18.0),
              ),
              Text(
                "$type",
                style: TextStyle(font: font, fontSize: 18.0),
              ),
            ],
          ),
          Container(
            height: 1,
            color: ColorUtils.toPdfColor(mt.Colors.black),
          ),
          Image(qrCode),
        ],
      ),
    );
  }
}
