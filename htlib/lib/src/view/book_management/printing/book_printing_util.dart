import 'dart:typed_data';

import 'package:htlib/src/model/book.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;
import 'package:barcode_image/barcode_image.dart' as qr;

class BookPrintingUtil {
  static pw.MemoryImage generateQrcode(Book book) {
    var image = img.Image(100, 100);
    qr.drawBarcode(image, qr.Barcode.qrCode(), "${book.isbn}");
    var barcode = pw.MemoryImage(img.encodePng(image) as Uint8List);
    return barcode;
  }
}
