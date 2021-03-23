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

  double get imageHeight => 60.0 * 3.0 + 2 * Insets.m;
  double get dialogHeight => PageBreak.defaultPB.isMobile(context)
      ? double.infinity
      : 586.0 + Insets.m;
  double get dialogWidth => PageBreak.defaultPB.isDesktop(context)
      ? 1100.0
      : PageBreak.defaultPB.isTablet(context)
          ? PageBreak.defaultPB.mobile
          : MediaQuery.of(context).size.width;
  double get textFieldWidth => PageBreak.defaultPB.isDesktop(context)
      ? 1100.0 - 230.0
      : PageBreak.defaultPB.isTablet(context)
          ? PageBreak.defaultPB.mobile - 230.0
          : MediaQuery.of(context).size.width;

  TextEditingController _isbnController = TextEditingController();
  FocusNode _isbnNode = FocusNode();
  String _isbnValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống mã ISBN";
    int containChar = int.tryParse(value);
    if (containChar == null) return "Mã ISBN chỉ chứa chữ số";

    return null;
  }

  TextEditingController _nameController = TextEditingController();
  FocusNode _nameNode = FocusNode();
  String _nameValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống tên sách";

    return null;
  }

  TextEditingController _priceController = TextEditingController(text: "0");
  FocusNode _priceNode = FocusNode();
  String _priceValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống giá tiền";
    value = value.replaceAll(RegExp(r','), "");
    int containChar = int.tryParse(value);
    if (containChar == null) return "Giá tiền chỉ chứa chữ số";

    return null;
  }

  TextEditingController _publisherController = TextEditingController();
  FocusNode _publisherNode = FocusNode();
  String _publisherValidator(String value) {
    return null;
  }

  TextEditingController _yearController = TextEditingController();
  FocusNode _yearNode = FocusNode();
  String _yearValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống năm xuất bản";
    int containChar = int.tryParse(value);
    if (containChar == null) return "Năm chỉ chứa chữ số";
    if (containChar > DateTime.now().year)
      return "Năm sản xuất phải trước hiện tại";
    return null;
  }

  TextEditingController _typeController = TextEditingController();
  FocusNode _typeNode = FocusNode();
  String _typeValidator(String value) {
    return null;
  }

  Set<String> classifyTypeList = Set<String>();
  Set<String> _type = Set<String>();

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
                          type: _type.toList(),
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

  Widget _dataField() {
    return Theme(
      data: Theme.of(context)
          .copyWith(accentColor: Theme.of(context).primaryColor),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              validator: _nameValidator,
              focusNode: _nameNode,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_isbnNode),
              decoration: InputDecoration(filled: true, labelText: "Tên sách"),
            ).paddingOnly(right: Insets.m),
            VSpace(Insets.m),
            TextFormField(
              controller: _isbnController,
              validator: _isbnValidator,
              focusNode: _isbnNode,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_priceNode),
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
                        String data = await bookService.addingBookDialogService
                            .getISBNCode(context);

                        _isbnController.clear();
                        _isbnController.text = data;
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ).paddingOnly(right: Insets.m),
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
                          focusNode: _priceNode,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_yearNode),
                          keyboardType: TextInputType.numberWithOptions(),
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
                Container(
                  width: PageBreak.defaultPB.isMobile(context)
                      ? (MediaQuery.of(context).size.width - 1 * Insets.m) / 2
                      : 55 * 4.0,
                  padding: EdgeInsets.only(right: Insets.m),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          child: Icon(Icons.remove),
                        ),
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(Size(55.0, 55.0)),
                          alignment: Alignment.center,
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                      ),
                      Text(
                        "$_quantity",
                        style: Theme.of(context).textTheme.button.copyWith(
                            fontSize:
                                Theme.of(context).textTheme.bodyText1.fontSize),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _quantity++;
                          setState(() {});
                        },
                        child: SizedBox(
                          height: 55.0,
                          width: 55.0,
                          child: Icon(Icons.add),
                        ),
                        style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(Size(55.0, 55.0)),
                          alignment: Alignment.center,
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
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
                    focusNode: _yearNode,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_publisherNode),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                    focusNode: _publisherNode,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_typeNode),
                    decoration: InputDecoration(
                      filled: true,
                      labelText: "Nhà xuất bản",
                    ),
                  ),
                ),
              ],
            ).paddingOnly(right: Insets.m),
            VSpace(Insets.m),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Thể loại",
                      style: Theme.of(context).textTheme.headline6,
                    ).paddingOnly(left: Insets.m).expanded(),
                    HSpace(Insets.m),
                    TextFormField(
                      controller: _typeController,
                      validator: _typeValidator,
                      focusNode: _typeNode,
                      onTap: () {},
                      onFieldSubmitted: (value) {
                        _type.add(value);
                        if (!classifyTypeList.contains(value))
                          classifyTypeList.add(value);

                        _typeController.clear();
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Thêm thể loại mới",
                      ),
                    ).expanded(),
                  ],
                ),
                VSpace(Insets.m),
                Wrap(
                  spacing: Insets.sm,
                  runSpacing: Insets.sm,
                  children: List.generate(
                    classifyTypeList.length,
                    (index) {
                      String typeString = classifyTypeList
                          .elementAt(classifyTypeList.length - index - 1);
                      return Tooltip(
                        message: typeString,
                        child: ChoiceChip(
                          label: Text(
                            typeString,
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: !_type.contains(typeString)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.7)
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                    ),
                          ),
                          selected: _type.contains(typeString),
                          selectedShadowColor: Theme.of(context).tileColor,
                          selectedColor:
                              Theme.of(context).colorScheme.secondary,
                          backgroundColor: Theme.of(context).tileColor,
                          onSelected: (select) {
                            if (select) {
                              _type.add(typeString);
                            } else {
                              if (!bookService.classifyTypeList
                                  .contains(typeString)) {
                                classifyTypeList.remove(typeString);
                              }
                              _type.remove(typeString);
                            }
                            setState(() {});
                          },
                          elevation: 1,
                          pressElevation: 3,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ).paddingOnly(right: Insets.m),
            VSpace(Insets.m),
          ],
        ),
      ).expanded(),
    );
  }

  @override
  void initState() {
    super.initState();
    classifyTypeList = Set<String>.from(bookService.classifyTypeList);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: !PageBreak.defaultPB.isMobile(context)
          ? Alignment.center
          : Alignment.bottomCenter,
      child: Material(
        elevation: 3.0,
        child: Container(
          constraints:
              BoxConstraints(maxHeight: dialogHeight, maxWidth: dialogWidth),
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
                      await bookService.excelService.getBookList(context);
                      Navigator.pop(context);
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
                  _dataField(),
                  _buildActionButton(padding: EdgeInsets.zero).paddingOnly(
                    bottom: Insets.m,
                    right: Insets.m,
                  ),
                ],
              ),
            ).padding(
              top: Insets.m,
              left: Insets.m,
            ),
          ),
        ),
      ),
    );
  }
}
