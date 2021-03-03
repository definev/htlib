import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/rest_utils.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/utils/painter/logo.dart';
import 'package:htlib/styles.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AddingBookDialog extends StatefulWidget {
  @override
  _AddingBookDialogState createState() => _AddingBookDialogState();
}

class _AddingBookDialogState extends State<AddingBookDialog> {
  final _formKey = GlobalKey<FormState>();
  BookService bookService = Get.find();

  TextEditingController _isbnController = TextEditingController();
  String _isbnValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống mã ISBN";
    int containChar = int.tryParse(value);
    if (containChar == null) return "Mã ISBN chỉ chứa chữ số";

    return null;
  }

  TextEditingController _nameController = TextEditingController();
  String _nameValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống tên sách";

    return null;
  }

  TextEditingController _priceController = TextEditingController(text: "0");
  String _priceValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống giá tiền";
    value = value.replaceAll(RegExp(r','), "");
    int containChar = int.tryParse(value);
    if (containChar == null) return "Giá tiền chỉ chứa chữ số";

    return null;
  }

  TextEditingController _publisherController = TextEditingController();
  String _publisherValidator(String value) {
    return null;
  }

  TextEditingController _yearController = TextEditingController();
  String _yearValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống năm xuất bản";
    int containChar = int.tryParse(value);
    if (containChar == null) return "Năm chỉ chứa chữ số";
    if (containChar > DateTime.now().year)
      return "Năm sản xuất phải trước hiện tại";
    return null;
  }

  TextEditingController _typeController = TextEditingController();
  String _typeValidator(String value) {
    return null;
  }

  int _quantity = 1;

  Widget _buildActionButton({EdgeInsets padding}) => Padding(
        padding: padding ??
            EdgeInsets.only(left: Insets.m, right: Insets.m, bottom: Insets.m),
        child: SizedBox(
          height: 53.0,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Hủy".toUpperCase(),
                  ).bigMode,
                ),
              ),
              HSpace(Insets.sm),
              Expanded(
                child: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate() == true) {
                        Book book = Book(
                          isbn: _isbnController.text,
                          name: _nameController.text,
                          publisher: _publisherController.text,
                          year: int.tryParse(_yearController.text),
                          price: int.tryParse(_priceController.text
                              .replaceAll(RegExp(r','), "")),
                          type: _typeController.text,
                          quantity: _quantity ?? 1,
                        );
                        bookService.add(book);

                        Navigator.pop(context);
                      } else {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).hideCurrentSnackBar();
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Nhập dữ liệu sai, vui lòng nhập lại"),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                              left: Insets.m,
                              right: Insets.m,
                              bottom: 2 * Insets.m + 50,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Thêm".toUpperCase(),
                    ).bigMode,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: !PageBreak.defaultPB.isMobile(context)
          ? Alignment.center
          : Alignment.bottomCenter,
      child: Material(
        elevation: 3.0,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: PageBreak.defaultPB.isMobile(context)
                ? double.infinity
                : 586.0 + Insets.m,
            maxWidth: PageBreak.defaultPB.isDesktop(context)
                ? 1200
                : PageBreak.defaultPB.isTablet(context)
                    ? PageBreak.defaultPB.mobile
                    : MediaQuery.of(context).size.width,
          ),
          color: Colors.white,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Nhập sách mới",
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.explicit),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (_) => LogoIndicator(
                          size:
                              PageBreak.defaultPB.isMobile(context) ? 150 : 300,
                        ).center(),
                      );
                      List<List<Book>> addList =
                          await bookService.excelService.getBookList();
                      Navigator.pop(context);
                      if (addList != null) {
                        addList.forEach((list) => bookService.addList(list));
                      } else {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).hideCurrentSnackBar();
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Chưa nhập mã ISBN")));
                      }
                    },
                    tooltip: "Thêm sách từ file excel",
                  ),
                ),
                Builder(
                  builder: (context) => IconButton(
                    onPressed: () {
                      if (_isbnController.text == "") {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).hideCurrentSnackBar();
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Chưa nhập mã ISBN")));
                      } else {
                        String params = RESTUtils.encodeParams(
                            {"q": "${_isbnController.text}"});
                        launch("https://www.google.com/search?$params");
                      }
                    },
                    icon: Icon(AntDesign.google),
                    tooltip: "Tìm kiếm trên google",
                  ).constrained(height: 30),
                ),
                HSpace(Insets.m),
              ],
            ),
            body: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          validator: _nameValidator,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: "Tên sách",
                          ),
                        ),
                        VSpace(Insets.m),
                        TextFormField(
                          controller: _isbnController,
                          validator: _isbnValidator,
                          keyboardType: TextInputType.numberWithOptions(),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            labelText: "Mã sách quốc tế ISBN",
                            suffixIcon: Builder(
                              builder: (context) {
                                return IconButton(
                                  icon: Icon(Icons.qr_code_scanner_rounded),
                                  onPressed: () async {
                                    String data = await bookService
                                        .addingBookDialogService
                                        .getISBNCode(context);

                                    _isbnController.clear();
                                    _isbnController.text = data;
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        VSpace(Insets.m),
                        Row(
                          children: [
                            Flexible(
                              flex:
                                  PageBreak.defaultPB.isMobile(context) ? 1 : 3,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _priceController,
                                      validator: _priceValidator,
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      inputFormatters: [ThousandsFormatter()],
                                      decoration: InputDecoration(
                                        filled: true,
                                        labelText: "Giá tiền",
                                        suffixText: "VND",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            HSpace(Insets.m),
                            Flexible(
                              child: Stack(
                                children: [
                                  Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                      borderRadius: Corners.s8Border,
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_quantity <= 1) return;
                                          _quantity--;
                                          setState(() {});
                                        },
                                        child: SizedBox(
                                          height: 55.0,
                                          width: 55.0,
                                          child: Icon(Icons.remove).center(),
                                        ),
                                        style: ButtonStyle(
                                          alignment: Alignment.center,
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero),
                                        ),
                                      ),
                                      Text(
                                        "$_quantity",
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .fontSize),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _quantity++;
                                          setState(() {});
                                        },
                                        child: SizedBox(
                                          height: 55.0,
                                          width: 55.0,
                                          child: Icon(Icons.add).center(),
                                        ),
                                        style: ButtonStyle(
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  Size(55.0, 55.0)),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        VSpace(Insets.m),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _yearController,
                                validator: _yearValidator,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: "Năm xuất bản",
                                ),
                              ),
                            ),
                            HSpace(Insets.m),
                            Expanded(
                              child: TextFormField(
                                controller: _publisherController,
                                validator: _publisherValidator,
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: "Nhà xuất bản",
                                ),
                              ),
                            ),
                          ],
                        ),
                        VSpace(Insets.m),
                        TextFormField(
                          controller: _typeController,
                          validator: _typeValidator,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: "Thể loại",
                          ),
                        ),
                        VSpace(Insets.m),
                      ],
                    ),
                  ).expanded(),
                  _buildActionButton(padding: EdgeInsets.zero)
                      .paddingOnly(bottom: Insets.m),
                ],
              ),
            ).padding(
              top: Insets.m,
              left: Insets.m,
              right: Insets.m,
            ),
          ),
        ),
      ),
    );
  }
}
