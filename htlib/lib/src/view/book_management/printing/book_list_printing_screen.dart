import 'dart:typed_data';

import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/view/book_management/printing/book_card_pdf_widget.dart';
import 'package:htlib/src/view/book_management/printing/book_printing_util.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class BookListPrintingScreen extends StatelessWidget {
  final List<Book> bookList;

  const BookListPrintingScreen(this.bookList, {Key key}) : super(key: key);

  Future<Uint8List> createPdf() async {
    final pdf = pw.Document();
    final _fontData = await rootBundle.load('assets/fonts/Typold.ttf');
    final font = pw.Font.ttf(_fontData);
    List<pw.Widget> children = [];

    bookList.forEach((book) {
      var barcode = BookPrintingUtil.generateBarcode(book);
      for (int i = 0; i < book.quantity; i++) {
        children.add(
          BookCard(
            book,
            font: font,
            qrCode: barcode,
          ),
        );
      }
    });

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(3),
        build: (pw.Context context) => pw.Wrap(
          spacing: 6,
          children: children,
        ),
      ),
    );

    return pdf.save();
  }

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
        build: (format) => createPdf(),
        initialPageFormat: PdfPageFormat.a4,
        canChangePageFormat: false,
      ),
    );
  }
}
