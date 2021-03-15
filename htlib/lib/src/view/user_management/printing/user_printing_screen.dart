import 'dart:typed_data';

import 'package:htlib/src/model/user.dart';
import 'package:htlib/styles.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show NetworkAssetBundle, rootBundle;

Future<Uint8List> createPdf(List<User> userList) async {
  final pdf = pw.Document();
  final fontData = await rootBundle.load('assets/fonts/Lobster-Regular.ttf');
  // final fontData = await rootBundle.load('assets/fonts/RobotoSlab-Regular.ttf');
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());
  Map<String, pw.MemoryImage> images = {};
  for (User e in userList) {
    final image =
        (await NetworkAssetBundle(Uri.parse(e.imageUrl)).load(e.imageUrl))
            .buffer
            .asUint8List();
    images.addEntries([MapEntry(e.id, pw.MemoryImage(image))]);
  }

  pdf.addPage(
    pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Wrap(
            children:
                userList.map((e) => _UserCard(e, ttf, images[e.id])).toList(),
          );
        }),
  );
  return pdf.save();
}

class _UserCard extends pw.StatelessWidget {
  final User user;
  final pw.Font font;
  final pw.MemoryImage image;

  _UserCard(this.user, this.font, this.image);
  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      height: 150,
      width: 250,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      padding: pw.EdgeInsets.all(Insets.m),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            "Sở giáo dục đào tạo Bắc Ninh",
            style: pw.TextStyle(font: font, fontSize: 9),
          ),
          pw.Text(
            "Trường trung học phổ thông hàn thuyên".toUpperCase(),
            style: pw.TextStyle(font: font, fontSize: FontSizes.s11),
          ),
          pw.SizedBox(height: Insets.sm),
          pw.Row(
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Image(
                  image,
                  width: 60,
                  height: 80,
                  fit: pw.BoxFit.cover,
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  children: [
                    pw.Text(
                      "Thẻ thư viện",
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 20,
                        color: PdfColor.fromHex("#FFF212"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserPrintingScreen extends StatelessWidget {
  final List<User> userList;

  const UserPrintingScreen(this.userList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("In thẻ thư viện"),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => createPdf(userList),
        pdfFileName: "thẻ thư viện",
      ),
    );
  }
}
