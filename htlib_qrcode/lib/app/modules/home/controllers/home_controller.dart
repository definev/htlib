import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:htlib_qrcode/app/repos/htlib_cli_repos.dart';

class HomeController extends GetxController {
  void barcodeScan() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "HỦY",
      true,
      ScanMode.BARCODE,
    );
    if (barcodeScanRes != null) {
      await HtlibCliRepos.book.fireNewISBN(barcodeScanRes);
    }
  }

  void qrcodeScan() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "HỦY",
      true,
      ScanMode.QR,
    );
    if (barcodeScanRes != null) {
      await HtlibCliRepos.book.fireNewISBN(barcodeScanRes);
    }
  }

  @override
  void onInit() {}
  @override
  void onReady() {}
  @override
  void onClose() {}
}
