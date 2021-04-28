import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddingBookDialogService {
  Future<String> getISBNCode(BuildContext context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      false,
      ScanMode.BARCODE,
    );
    return barcodeScanRes;
  }
}
