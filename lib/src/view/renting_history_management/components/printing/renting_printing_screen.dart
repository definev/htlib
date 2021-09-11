import 'package:flutter/material.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/view/renting_history_management/components/printing/invoice/model/customer.dart';
import 'package:htlib/src/view/renting_history_management/components/printing/invoice/model/invoice.dart';
import 'package:htlib/src/view/renting_history_management/components/printing/invoice/model/supplier.dart';
import 'package:htlib/src/view/renting_history_management/components/printing/invoice/pdf_invoice_api.dart';
import 'package:printing/printing.dart';

//TODO: Complete Invoice
class RentingPrintingScreen extends StatelessWidget {
  final RentingHistory rentingHistory;

  const RentingPrintingScreen({Key? key, required this.rentingHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PdfPreview(
        build: (_) => PdfInvoiceApi.generate(
          Invoice(
            info: InvoiceInfo(
              date: DateTime.now(),
              description: "",
              dueDate: DateTime.now(),
              number: '',
            ),
            supplier: Supplier(
              name: "",
              address: "",
              paymentInfo: "",
            ),
            customer: Customer(address: "", name: ""),
            items: [],
          ),
        ),
      ),
    );
  }
}
