import 'dart:typed_data';

import 'package:barcode_image/barcode_image.dart' as qr;
import 'package:htlib/src/model/book.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'book_card_pdf_widget.dart';

Future<Uint8List> createPdf(Book book) async {
  final pdf = pw.Document();
  final _fontData = await rootBundle.load('assets/fonts/Typold.ttf');
  final font = pw.Font.ttf(_fontData);
  var image = img.Image(190, 70);
  qr.drawBarcode(image, qr.Barcode.code128(), "${book.isbn}");
  var qrCode = pw.MemoryImage(img.encodePng(image) as Uint8List);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(3),
      build: (pw.Context context) => pw.Wrap(
        spacing: 6,
        children: List.generate(
          book.quantity,
          (index) {
            return BookCard(
              book,
              font: font,
              qrCode: qrCode,
            );
          },
        ),
      ),
    ),
  );

  return pdf.save();
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
