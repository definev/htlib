import 'dart:typed_data';

import 'package:htlib/_internal/utils/color_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/styles.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show NetworkAssetBundle, rootBundle;

Future<Uint8List> createPdf(List<User> userList) async {
  final placeHolderByteData =
      (await rootBundle.load("assets/images/lib.jpg")).buffer.asUint8List();
  final placeHolderImg = pw.MemoryImage(placeHolderByteData);
  final pdf = pw.Document();
  final _titleFontData = await rootBundle.load('assets/fonts/Habano.ttf');
  final _subtitleFontData = await rootBundle.load('assets/fonts/Guanine.ttf');
  final _bodyFontData = await rootBundle.load('assets/fonts/Hanzel.ttf');
  final title = pw.Font.ttf(_titleFontData.buffer.asByteData());
  final subtitle = pw.Font.ttf(_subtitleFontData.buffer.asByteData());
  final body = pw.Font.ttf(_bodyFontData.buffer.asByteData());
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
            children: userList
                .map(
                  (e) => _UserCard(
                    e,
                    images[e.id],
                    title: title,
                    subtitle: subtitle,
                    body: body,
                    placeHolder: placeHolderImg,
                  ),
                )
                .toList(),
          );
        }),
  );
  return pdf.save();
}

class _UserCard extends pw.StatelessWidget {
  final User user;
  final pw.Font title;
  final pw.Font subtitle;
  final pw.Font body;
  final pw.MemoryImage image;
  final pw.MemoryImage placeHolder;

  _UserCard(
    this.user,
    this.image, {
    this.placeHolder,
    this.title,
    this.subtitle,
    this.body,
  });
  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      height: 1240 / 6,
      width: 1748 / 6,
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex("#F7F7F7"),
        border: pw.Border.all(
          color: ColorUtils.toPdfColor(Colors.black),
          width: 0.5,
        ),
      ),
      margin: pw.EdgeInsets.only(bottom: Insets.m - 3),
      child: pw.Row(
        children: [
          pw.Flexible(
            flex: 3,
            child: pw.Stack(
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.all(0.5),
                  child: pw.Image(placeHolder, fit: pw.BoxFit.cover),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(
                    vertical: Insets.m - 3,
                    horizontal: Insets.m - 3,
                  ),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Container(
                        height: 80.0,
                        width: 1748 / 18,
                        decoration: pw.BoxDecoration(
                          color: ColorUtils.toPdfColor(Colors.white),
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                      ),
                      pw.Container(
                        height: 20.0,
                        width: 1748 / 18,
                        decoration: pw.BoxDecoration(
                          color: ColorUtils.toPdfColor(Colors.white),
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          "${DateFormat("EEEE dd/MM/yyyy", "VI").format(DateTime.now())}",
                          style: pw.TextStyle(font: body, fontSize: 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.Flexible(
            flex: 5,
            child: pw.Container(
              padding: pw.EdgeInsets.all(Insets.m - 3),
              child: pw.Column(
                children: [
                  pw.Flexible(
                    flex: 4,
                    child: pw.Container(
                      height: 80,
                      decoration: pw.BoxDecoration(
                        color: ColorUtils.toPdfColor(Colors.white),
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.only(left: Insets.m - 3),
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "${user.name}",
                                  style: pw.TextStyle(
                                      font: subtitle, fontSize: FontSizes.s11),
                                ),
                                pw.Text(
                                  "ID: ${user.id.substring(0, 5)}",
                                  style: pw.TextStyle(
                                      font: body, fontSize: FontSizes.s11),
                                ),
                              ],
                            ),
                          ),
                          pw.ClipRRect(
                            verticalRadius: 4.0,
                            horizontalRadius: 4.0,
                            child: pw.Container(
                              color: ColorUtils.toPdfColor(Colors.blue),
                              height: 80,
                              width: 60,
                              child: pw.Image(
                                image,
                                fit: pw.BoxFit.cover,
                                height: 80,
                                width: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.Flexible(
                    flex: 5,
                    child: pw.Column(
                      children: [
                        pw.Expanded(
                          child: _InfomationRow("SDT", "${user.phone}", body),
                        ),
                        pw.Expanded(
                          child: _InfomationRow(
                              "Lớp", "${user.currentClass}", body),
                        ),
                        pw.Expanded(
                          child: _InfomationRow(
                              "Địa chỉ", "${user.address}", body),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfomationRow extends pw.StatelessWidget {
  final String title;
  final String content;
  final pw.Font font;

  _InfomationRow(this.title, this.content, this.font);

  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          width: Insets.xl,
          child: pw.Text(
            title,
            style: pw.TextStyle(font: font, fontSize: 8),
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  content,
                  style: pw.TextStyle(font: font, fontSize: 8),
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Container(
                height: 0.5,
                color: ColorUtils.toPdfColor(Colors.blue[900]),
              ),
            ],
          ),
        ),
      ],
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
        title: Text(
          "In thẻ thư viện",
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: PdfPreview(
        maxPageWidth: 1200,
        build: (format) => createPdf(userList),
        pdfFileName: "thẻ thư viện",
      ),
    );
  }
}
