import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/rest_utils.dart';
import 'package:htlib/src/model/book_base.dart';
import 'package:htlib/src/services/book/book_service.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AddingBookDialog extends StatefulWidget {
  @override
  _AddingBookDialogState createState() => _AddingBookDialogState();
}

class _AddingBookDialogState extends State<AddingBookDialog> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _isbnController = TextEditingController();
  String _isbnValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống mã ISBN";
    int containChar = int.tryParse(value);
    if (containChar == null) return "Mã ISBN chỉ chứa chữ số";

    return null;
  }

  String _nameValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống tên sách";

    return null;
  }

  String _publisherValidator(String value) {
    return null;
  }

  String _yearValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống năm xuất bản";
    int containChar = int.tryParse(value);
    if (containChar == null) return "Năm chỉ chứa chữ số";
    if (containChar > DateTime.now().year)
      return "Năm sản xuất phải trước hiện tại";
    return null;
  }

  String _priceValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống giá tiền";
    int containChar = int.tryParse(value);
    if (containChar == null) return "Mã ISBN chỉ chứa chữ số";

    return null;
  }

  String _typeValidator(String value) {
    return null;
  }

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
            maxHeight: 396,
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
                    BookService bookService = GetIt.instance<BookService>();
                    List<BookBase> addList =
                        await bookService.excelService.getBookBaseList();
                    if (addList != null) bookService.mergeList(addList);
                  },
                  tooltip: "Thêm sách từ file excel",
                ),
                IconButton(
                  onPressed: () {
                    String params = RESTUtils.encodeParams(
                        {"q": "Bùi Đại Dương Và Bùi văn Quân"});
                    launch("https://www.google.com/search?$params");
                  },
                  icon: Icon(AntDesign.google),
                  tooltip: "Tìm kiếm trên google",
                ).constrained(height: 30),
                HSpace(Insets.m),
              ],
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: _nameValidator,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: "Tên sách",
                    ),
                  ),
                  VSpace(Insets.m),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: _isbnValidator,
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: "Mã sách quốc tế ISBN",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      HSpace(Insets.m),
                      PageBreak.defaultPB.isMobile(context)
                          ? Expanded(
                              child: Row(
                                children: [
                                  OutlinedButton(
                                    onPressed: () {},
                                    child: Container(
                                      height: 50.0,
                                      width: 40.0,
                                      child: Icon(
                                          Icons.arrow_drop_down_outlined,
                                          size: 30),
                                    ),
                                  ),
                                  HSpace(Insets.m),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder()),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  HSpace(Insets.m),
                                  OutlinedButton(
                                    onPressed: () {},
                                    child: Container(
                                      height: 53.0,
                                      width: 40.0,
                                      child: Icon(Icons.arrow_drop_up_outlined,
                                          size: 30),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Row(
                              children: [
                                OutlinedButton(
                                  onPressed: () {},
                                  child: Container(
                                    height: 50.0,
                                    width: 40.0,
                                    child: Icon(Icons.arrow_drop_down_outlined,
                                        size: 30),
                                  ),
                                ),
                                HSpace(Insets.m),
                                Container(
                                  width: 70.0,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder()),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                HSpace(Insets.m),
                                OutlinedButton(
                                  onPressed: () {},
                                  child: Container(
                                    height: 53.0,
                                    width: 40.0,
                                    child: Icon(Icons.arrow_drop_up_outlined,
                                        size: 30),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                  VSpace(Insets.m),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: _yearValidator,
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
                    validator: _typeValidator,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: "Thể loại",
                    ),
                  ),
                  VSpace(Insets.m),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
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
                                Navigator.pop(context);
                              } else {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Nhập dữ liệu sai, vui lòng nhập lại",
                                    ),
                                    behavior: SnackBarBehavior.floating,
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
                ],
              ),
            ).padding(all: Insets.m),
          ),
        ),
      ),
    );
  }
}
