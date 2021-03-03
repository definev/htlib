import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/_internal/utils/rest_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/styles.dart';
import 'package:uuid/uuid.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AddingUserDialog extends StatefulWidget {
  @override
  _AddingUserDialogState createState() => _AddingUserDialogState();
}

class _AddingUserDialogState extends State<AddingUserDialog> {
  final _formKey = GlobalKey<FormState>();
  UserService userService = Get.find();
  Uint8List _memoryImg;
  Color _disableColor;

  TextEditingController _identityCardController = TextEditingController();
  String _isbnValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống số chứng minh nhân dân";
    int containChar = int.tryParse(value);
    if (containChar == null) return "Mã ISBN chỉ chứa chữ số";

    return null;
  }

  TextEditingController _nameController = TextEditingController();
  String _nameValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống trường này";

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
                        //TODO: Update user object
                        var uuid = Uuid();

                        User user = User(
                          id: uuid.v4(),
                          name: _nameController.text,
                          image: "",
                          currentClass: "",
                          phone: "",
                          status: UserStatus.normal,
                        );
                        userService.add(user);

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
                "Thêm người dùng",
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    onPressed: () {
                      if (_identityCardController.text == "") {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).hideCurrentSnackBar();
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Chưa nhập số chứng minh nhân dân")));
                      } else {
                        String params = RESTUtils.encodeParams(
                            {"q": "${_identityCardController.text}"});
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _memoryImg != null
                                ? Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                          ),
                                          borderRadius: Corners.s5Border,
                                        ),
                                        child: Image.memory(
                                          _memoryImg,
                                          width: 60 * 3.0 + 2 * Insets.m,
                                          height: 60 * 3.0 + 2 * Insets.m,
                                          fit: BoxFit.cover,
                                        ).clipRRect(all: Corners.s5),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          margin: EdgeInsets.all(Insets.sm),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.4),
                                            borderRadius: Corners.s5Border,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        ).gestures(
                                          onTap: () => setState(
                                            () => _memoryImg = null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                    .constrained(
                                      height: 60 * 3.0 + 2 * Insets.m,
                                    )
                                    .paddingOnly(right: Insets.m)
                                : MouseRegion(
                                    onHover: (_) {
                                      setState(() {
                                        _disableColor = Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5);
                                      });
                                    },
                                    onExit: (_) {
                                      setState(() {
                                        _disableColor = Theme.of(context)
                                            .disabledColor
                                            .withOpacity(0.5);
                                      });
                                    },
                                    child: DottedBorder(
                                      radius: Corners.s10Radius,
                                      borderType: BorderType.RRect,
                                      dashPattern: [
                                        Insets.m,
                                        Insets.m,
                                        Insets.m
                                      ],
                                      color: _disableColor ??
                                          Theme.of(context).disabledColor,
                                      child: Container(
                                        width: 60 * 3.0 + 2 * Insets.m,
                                        height: 60 * 3.0 + 2 * Insets.m,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              icon: Icon(Ionicons.ios_camera),
                                              iconSize: 40.0,
                                              color: _disableColor ??
                                                  Theme.of(context)
                                                      .disabledColor,
                                              onPressed: () async {
                                                _memoryImg =
                                                    await FileUtils.image();
                                                setState(() {});
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Ionicons.ios_image),
                                              iconSize: 40.0,
                                              color: _disableColor ??
                                                  Theme.of(context)
                                                      .disabledColor,
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).paddingOnly(right: Insets.m),
                                  ),
                            Column(
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  validator: _nameValidator,
                                  decoration: InputDecoration(
                                    filled: true,
                                    labelText: "Họ và tên",
                                  ),
                                ),
                                VSpace(Insets.m),
                                TextFormField(
                                  controller: _identityCardController,
                                  validator: _isbnValidator,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ],
                                  decoration: InputDecoration(
                                    filled: true,
                                    labelText: "Mã chứng minh thư nhân dân",
                                    suffixIcon: Builder(
                                      builder: (context) {
                                        return IconButton(
                                          icon: Icon(Icons.camera),
                                          onPressed: () async {
                                            //TODO: Add identity card infomation
                                            _identityCardController.clear();
                                            setState(() {});
                                          },
                                        );
                                      },
                                    ),
                                  ),
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
                            ).expanded(),
                          ],
                        ),
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
