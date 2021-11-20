import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:htlib/_internal/utils/color_utils.dart';
import 'package:htlib/src/widget/qr_scanner_dialog.dart';
import 'package:intl/intl.dart';
import 'package:ps_flutter_barcode_scanner/ps_flutter_barcode_scanner.dart';

class Utils {
  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static Future<String?> scanQrcode(BuildContext context) =>
      showDialog(context: context, builder: (_) => QRScannerDialog());

  static Future<String?> scanISBNCode(BuildContext context) async {
    try {
      String? barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        Theme.of(context).primaryColor.toHex(),
        'Hủy',
        false,
        ScanMode.BARCODE,
      );
      return barcodeScanRes;
    } catch (e) {
      return null;
    }
  }

  static bool get isMouseConnected => RendererBinding.instance!.mouseTracker.mouseIsConnected;

  static void unFocus() {
    WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
  }

  static void benchmark(String name, void Function() test) {
    int ms = DateTime.now().millisecondsSinceEpoch;
    test();
    log(
      "Benchmark: $name == ${DateTime.now().millisecondsSinceEpoch - ms}ms",
      name: "_internal/utils/utils.dart",
    );
  }

  static String formatPrice(double price) {
    return NumberFormat.currency(locale: 'vi', symbol: 'VND', decimalDigits: 0)
        .format(price);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
