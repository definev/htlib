import 'dart:typed_data';

import 'package:barcode_image/barcode_image.dart' as qr;
import 'package:htlib/_internal/utils/color_utils.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/styles.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List> createPdf(List<User> userList) async {
  final placeHolderByteData =
      (await rootBundle.load("assets/images/logo.png")).buffer.asUint8List();
  final placeHolderImg = pw.MemoryImage(placeHolderByteData);
  final pdf = pw.Document();
  final _titleFontData = await rootBundle.load('assets/fonts/Typold.ttf');
  final _bodyFontData = await rootBundle.load('assets/fonts/Guanine.ttf');
  final title = pw.Font.ttf(_titleFontData);
  final body = pw.Font.ttf(_bodyFontData);
  // Map<String, pw.MemoryImage> images = {};
  // for (User e in userList) {
  //   final image =
  //       (await NetworkAssetBundle(Uri.parse(e.imageUrl)).load(e.imageUrl))
  //           .buffer
  //           .asUint8List();
  //   images.addEntries([MapEntry(e.id, pw.MemoryImage(image))]);
  // }

  var _userPages = <List<User>>[];

  for (int i = 0; i < userList.length; i++) {
    if (i % 8 == 0) {
      _userPages.add([userList[i]]);
    } else {
      var users = _userPages[_userPages.length - 1];
      users.add(userList[i]);
      _userPages[_userPages.length - 1] = users;
    }
  }

  _userPages.forEach((userList) {
    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(3),
          build: (pw.Context context) {
            return pw.Wrap(
              spacing: 6,
              children: userList.map(
                (e) {
                  var image = img.Image(100, 100);
                  qr.drawBarcode(image, qr.Barcode.qrCode(), "${e.id}");
                  var qrCode =
                      pw.MemoryImage(img.encodePng(image) as Uint8List);

                  return _UserCard(
                    e,
                    title: title,
                    body: body,
                    placeHolder: placeHolderImg,
                    qrCode: qrCode,
                  );
                },
              ).toList(),
            );
          }),
    );
  });

  return pdf.save();
}

class _UserCard extends pw.StatelessWidget {
  final User user;
  final pw.Font? title;
  final pw.Font? body;
  final pw.MemoryImage? placeHolder;
  final pw.MemoryImage? qrCode;

  _UserCard(
    this.user, {
    this.placeHolder,
    this.title,
    this.body,
    this.qrCode,
  });
  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      height: 1100 / 6,
      width: 1748 / 6,
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(5),
        gradient: pw.LinearGradient(
          colors: [
            PdfColor.fromHex("#4895ef"),
            // PdfColor.fromHex("#4cc9f0"),
            PdfColor.fromHex("#4361ee"),
          ],
          end: pw.Alignment.topCenter,
          begin: pw.Alignment.bottomCenter,
        ),
        // color: PdfColor.fromHex("#4895ef"),
      ),
      margin: pw.EdgeInsets.only(bottom: 6),
      padding: pw.EdgeInsets.all(Insets.m),
      child: pw.Stack(
        children: [
          pw.Padding(
            padding: pw.EdgeInsets.only(left: Insets.m),
            child: pw.Transform(
              transform: Matrix4.skewX(-3),
              child: pw.Opacity(
                opacity: 0.2,
                child: pw.Image(
                  placeHolder!,
                  fit: pw.BoxFit.contain,
                ),
              ),
            ),
          ),
          pw.Column(
            children: [
              pw.Flexible(
                flex: 5,
                child: pw.Container(),
                // child: pw.Row(
                //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                //   children: [
                //     pw.ClipRRect(
                //       horizontalRadius: 5,
                //       verticalRadius: 5,
                //       child: pw.Container(
                //         height: (1100 / 6 - 2 * Insets.m + 4) / 9 * 5,
                //         width: (1100 / 6 - 2 * Insets.m + 4) / 9 * 5 * 3 / 4,
                //         color: ColorUtils.toPdfColor(Colors.yellow[800]),
                //         child: pw.Image(
                //           image,
                //           height: (1100 / 6 - 2 * Insets.m + 4) / 9 * 5,
                //           width: (1100 / 6 - 2 * Insets.m + 4) / 9 * 5 * 3 / 4,
                //           fit: pw.BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ),
              pw.Container(
                height: 70.0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "${StringUtils.nameFormat(user.name)}",
                          style: pw.TextStyle(
                            font: body!,
                            color: ColorUtils.toPdfColor(Colors.white),
                            fontSize: 20,
                          ),
                        ),
                        pw.Text(
                          "SDT: ${user.phone}",
                          style: pw.TextStyle(
                            font: title!,
                            color: ColorUtils.toPdfColor(Colors.white),
                            fontSize: 12,
                          ),
                        ),
                        pw.Text(
                          "Lớp: ${user.className}",
                          style: pw.TextStyle(
                            font: title!,
                            color: ColorUtils.toPdfColor(Colors.white),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.only(
                          bottomRight: pw.Radius.circular(5),
                          topLeft: pw.Radius.circular(5),
                        ),
                        color: ColorUtils.toPdfColor(Colors.white),
                      ),
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "${DateFormat("dd/MM/yyyy").format(DateTime.now().add(Duration(days: 365)))}",
                            style: pw.TextStyle(
                              font: title!,
                              fontSize: 8,
                            ),
                          ),
                          pw.SizedBox(
                              height: 47,
                              width: 47,
                              child: pw.Image(qrCode!,
                                  height: 47, width: 47, fit: pw.BoxFit.cover)),
                        ],
                      ),
                      padding: pw.EdgeInsets.only(
                          left: 5, right: 5, bottom: 5, top: 4),
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

  const UserPrintingScreen(this.userList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("In thẻ thư viện")),
      body: PdfPreview(
        maxPageWidth: 1280,
        build: (format) => createPdf(userList),
        initialPageFormat: PdfPageFormat.a4,
        canChangePageFormat: false,
      ),
    );
  }
}
