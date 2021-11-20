import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/view/renting_history_management/components/printing/invoice/model/invoice.dart';
import 'package:htlib/src/view/renting_history_management/components/printing/invoice/model/supplier.dart';
import 'package:htlib/src/view/renting_history_management/components/printing/invoice/pdf_invoice_api.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

//TODO: Complete Invoice
class RentingHistoryPrintingScreen extends StatelessWidget {
  final RentingHistory rentingHistory;
  final User user;

  const RentingHistoryPrintingScreen(
      {Key? key, required this.rentingHistory, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Book> bookList =
        Get.find<BookService>().getListDataByMap(rentingHistory.bookMap);

    return Scaffold(
      appBar: AppBar(),
      body: PdfPreview(
        build: (_) async {
          final fontData = (await rootBundle.load('assets/fonts/Typold.ttf'));
          var typold = pw.Font.ttf(fontData);

          return PdfInvoiceApi.generate(
            Invoice(
              info: InvoiceInfo(
                description:
                    'Hóa đơn mượn sách của ${user.name} (${user.className})',
                date: rentingHistory.createAt,
                dueDate: rentingHistory.endAt,
                id: rentingHistory.id,
              ),
              supplier: Supplier(
                name: "Thư viện Hàn Thuyên",
                address: "Trường THPT Hàn Huyên, Đại Phúc, Bắc Ninh",
                paymentInfo: "",
              ),
              customer: user,
              items: rentingHistory.bookMap.keys.map(
                (key) {
                  final book = bookList.firstWhere((book) => book.isbn == key);
                  return InvoiceItem(
                    description: book.name,
                    date: rentingHistory.createAt,
                    quantity: rentingHistory.bookMap[key] ?? 1,
                    vat: 0,
                    unitPrice: book.price.toDouble(),
                  );
                },
              ).toList(),
            ),
            typold,
          );
        },
      ),
    );
  }
}
