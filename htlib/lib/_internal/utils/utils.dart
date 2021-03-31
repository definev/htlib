import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:htlib/_internal/utils/color_utils.dart';

class Utils {
  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static bool get isMouseConnected =>
      RendererBinding.instance!.mouseTracker.mouseIsConnected;

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

  static Stream<String?> scan(
    BuildContext context, {
    Function()? onCancel,
    Function(String?)? onReceive,
  }) =>
      FlutterBarcodeScanner.getBarcodeStreamReceiver(
        Theme.of(context).primaryColor.toHex(),
        "HỦY",
        true,
        ScanMode.DEFAULT,
      )!
          .map<String?>((event) {
        onReceive?.call(event?.toString());
        return event?.toString();
      });

  static Future<String> scanBarcode(BuildContext context,
      {Function()? onCancel}) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      Theme.of(context).primaryColor.toHex(),
      "HỦY",
      true,
      ScanMode.BARCODE,
    );
    return barcodeScanRes;
  }

  static Future<String> scanQrcode(BuildContext context,
      {Function()? onCancel}) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      Theme.of(context).primaryColor.toHex(),
      "HỦY",
      true,
      ScanMode.QR,
    );
    return barcodeScanRes;
  }
}
