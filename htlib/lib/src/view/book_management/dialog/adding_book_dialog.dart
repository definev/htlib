import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/rest_utils.dart';
import 'package:htlib/src/model/book_base.dart';
import 'package:htlib/src/services/book_service.dart';
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
              Builder(
                builder: (context) => Expanded(
                  child: ElevatedButton(
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
                                  Text("Nhập dữ liệu sai, vui lòng nhập lại")),
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
      alignment: PageBreak.defaultPB.isDesktop(context)
          ? Alignment.center
          : Alignment.bottomCenter,
      child: Material(
        elevation: 5.0,
        shadowColor: Colors.white.withOpacity(0.3),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 586.0 + Insets.m,
            maxWidth: PageBreak.defaultPB.isDesktop(context)
                ? 1200
                : MediaQuery.of(context).size.width,
          ),
          color: Colors.white,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Nhập sách mới"),
              actions: [
                IconButton(
                  icon: Icon(Icons.explicit),
                  onPressed: () async {
                    List<Book> addList =
                        await bookService.excelService.getBookList();
                    if (addList != null) bookService.addList(addList);
                  },
                  tooltip: "Thêm sách từ file excel",
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: IgnorePointer(
                child: Opacity(
              opacity: 0.0,
              child: _buildActionButton(),
            )),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
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
                          flex: PageBreak.defaultPB.isMobile(context) ? 1 : 3,
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_quantity <= 1) return;
                                    _quantity--;
                                    setState(() {});
                                  },
                                  child: Icon(Icons.remove),
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        Size(55.0, 55.0)),
                                    alignment: Alignment.center,
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero),
                                  ),
                                ),
                                Text(
                                  "$_quantity",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _quantity++;
                                    setState(() {});
                                  },
                                  child: Icon(Icons.add),
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        Size(55.0, 55.0)),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero),
                                  ),
                                ),
                              ],
                            ),
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
                    _buildActionButton(padding: EdgeInsets.zero),
                    VSpace(Insets.m),
                  ],
                ),
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
