import 'dart:io';
import 'dart:typed_data';

import 'package:htlib/_internal/utils/utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/view/renting_history_management/components/printing/invoice/model/invoice.dart';
import 'package:htlib/src/view/renting_history_management/components/printing/invoice/model/supplier.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }
}

class PdfInvoiceApi {
  static Future<Uint8List> generate(
    Invoice invoice,
    Font font,
  ) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice, font),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice, font),
        buildInvoice(invoice, font),
        Divider(),
        buildTotal(invoice, font),
      ],
      footer: (context) => buildFooter(invoice, font),
    ));

    return pdf.save();
  }

  static Widget buildHeader(Invoice invoice, Font font) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier, font),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.id,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer, font),
              buildInvoiceInfo(invoice.info, font),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(User user, Font font) => SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name,
                style: TextStyle(fontWeight: FontWeight.bold, font: font)),
            Text(user.phone, style: TextStyle(font: font)),
            Text(user.address, style: TextStyle(font: font)),
          ],
        ),
      );

  static Widget buildInvoiceInfo(InvoiceInfo info, Font font) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} ngày';
    final titles = <String>[
      'Ngày mượn sách:',
      'Ngày trả sách:',
      'Ngày còn lại:',
    ];
    final data = <String>[
      Utils.formatDate(info.date),
      Utils.formatDate(info.dueDate),
      paymentTerms,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(font, title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier, Font font) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name,
              style: TextStyle(
                font: font,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address, style: TextStyle(font: font)),
        ],
      );

  static Widget buildTitle(Invoice invoice, Font font) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BIÊN LAI MƯỢN SÁCH',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              font: font,
            ),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
            invoice.info.description,
            style: TextStyle(font: font),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice, Font font) {
    final headers = [
      'Tên sách',
      'Ngày mượn',
      'Số lượng',
      'Giá tiền',
      'Giá trị'
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.description,
        Utils.formatDate(item.date),
        '${item.quantity}',
        Utils.formatPrice(item.unitPrice),
        Utils.formatPrice(total),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle:
          TextStyle(fontWeight: FontWeight.bold, font: font, fontSize: 10),
      cellStyle: TextStyle(font: font, fontSize: 10),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice, Font font) {
    final netTotal = invoice.items.length == 0
        ? 0.0
        : invoice.items
            .map((item) => item.unitPrice * item.quantity)
            .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.length == 0 ? 0 : invoice.items.first.vat;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                buildText(
                  font,
                  title: 'Thành tiền',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    font: font,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice, Font font) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
            font,
            title: 'Địa chỉ:',
            value: invoice.supplier.address,
          ),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
            font,
            title: 'Biên lai in ngày',
            value: Utils.formatDate(DateTime.now()),
          ),
        ],
      );

  static buildSimpleText(
    Font font, {
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold, font: font);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value, style: TextStyle(font: font)),
      ],
    );
  }

  static buildText(
    Font font, {
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style =
        titleStyle ?? TextStyle(fontWeight: FontWeight.bold, font: font);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value,
              style:
                  unite ? style.copyWith(font: font) : TextStyle(font: font)),
        ],
      ),
    );
  }
}
