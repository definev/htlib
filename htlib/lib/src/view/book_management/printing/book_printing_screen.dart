import 'dart:typed_data';

import 'package:barcode_image/barcode_image.dart' as qr;
import 'package:htlib/_internal/utils/color_utils.dart';
import 'package:htlib/src/model/book.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List> createPdf(Book book) async {
  final pdf = pw.Document();
  final _titleFontData = await rootBundle.load('assets/fonts/Typold.ttf');
  final _bodyFontData = await rootBundle.load('assets/fonts/Guanine.ttf');
  final title = pw.Font.ttf(_titleFontData);
  final body = pw.Font.ttf(_bodyFontData);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(3),
      build: (pw.Context context) => pw.Wrap(
        spacing: 6,
        children: List.generate(
          book.quantity,
          (index) {
            var image = img.Image(190, 70);
            qr.drawBarcode(image, qr.Barcode.code128(), "${book.isbn}");
            var qrCode = pw.MemoryImage(img.encodePng(image) as Uint8List);

            return _BookCard(
              book,
              title: title,
              body: body,
              qrCode: qrCode,
            );
          },
        ),
      ),
    ),
  );

  return pdf.save();
}

class _BookCard extends pw.StatelessWidget {
  final Book book;
  final pw.Font title;
  final pw.Font body;
  final pw.MemoryImage qrCode;

  _BookCard(
    this.book, {
    this.title,
    this.body,
    this.qrCode,
  });
  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      height: 560 / 6,
      width: 800 / 6,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: ColorUtils.toPdfColor(Colors.black)),
      ),
      margin: pw.EdgeInsets.only(bottom: 6),
      padding: pw.EdgeInsets.all(10),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            "${book.typeToSafeString()}",
            style: pw.TextStyle(
              font: title,
              fontSize: 18.0,
            ),
          ),
          pw.Container(
            height: 1,
            color: ColorUtils.toPdfColor(Colors.black),
          ),
          pw.Image(qrCode),
        ],
      ),
    );
  }
}

class BookPrintingScreen extends StatelessWidget {
  final Book book;

  const BookPrintingScreen(this.book, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "In tem sách",
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: PdfPreview(
        maxPageWidth: 1280,
        build: (format) => createPdf(book),
        initialPageFormat: PdfPageFormat.a4,
        canChangePageFormat: false,
      ),
    );
  }
}
