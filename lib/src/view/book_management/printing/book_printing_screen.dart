import 'dart:typed_data';

import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/view/book_management/printing/book_printing_util.dart';
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
  var qrCode = BookPrintingUtil.generateQrcode(book);

  List<pw.Widget> children = List.generate(
      book.quantity, (index) => BookCard(book, font: font, qrCode: qrCode));

  List<List<pw.Widget>> _childrenList = [];

  int tilePerPage = 25;
  int page = children.length ~/ tilePerPage;
  int module = children.length % tilePerPage;
  for (int i = 0; i < page; i++)
    _childrenList.add(children
        .sublist(i * tilePerPage, i * tilePerPage + tilePerPage)
        .toList());
  if (module != 0)
    _childrenList.add(
        children.sublist(children.length - module, children.length).toList());

  _childrenList.forEach(
    (children) => pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(3),
        build: (pw.Context context) => pw.Wrap(children: children),
      ),
    ),
  );

  return pdf.save();
}

class BookPrintingScreen extends StatelessWidget {
  final Book book;

  const BookPrintingScreen(this.book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("In tem sách"),
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
