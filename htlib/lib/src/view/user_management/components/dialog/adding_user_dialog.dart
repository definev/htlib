import 'dart:convert';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/input_formatter.dart';
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
  bool _hover = false;
  bool _showImageError = false;

  TextEditingController _identityCardController = TextEditingController();
  String _identityCardValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống số chứng minh nhân dân";

    return null;
  }

  TextEditingController _nameController = TextEditingController();
  String _nameValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống họ và tên";

    return null;
  }

  TextEditingController _phoneController = TextEditingController();
  String _phoneValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống số điện thoại";
    return null;
  }

  TextEditingController _currentClassController = TextEditingController();
  String _currentClassValidator(String value) {
    return null;
  }

  double get imageHeight => 60.0 * 3.0 + 2 * Insets.m;
  double get dialogHeight => PageBreak.defaultPB.isMobile(context)
      ? MediaQuery.of(context).size.height
      : 5 * (59.0 + Insets.m);
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

  Widget _buildActionButton({EdgeInsets padding}) => Padding(
        padding: EdgeInsets.only(bottom: Insets.m, right: Insets.m),
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
                      if (_memoryImg == null) {
                        if (mounted) setState(() => _showImageError = true);
                        Future.delayed(4.seconds + 0.3.seconds, () {
                          if (mounted) setState(() => _showImageError = false);
                        });
                      }
                      if (_formKey.currentState.validate() == true) {
                        var uuid = Uuid();
                        User user = User(
                          id: uuid.v4(),
                          name: _nameController.text,
                          image: base64Encode(_memoryImg),
                          idNumberCard: _identityCardController.text,
                          currentClass:
                              _currentClassController.text.replaceAll("-", ""),
                          phone: _phoneController.text.replaceAll("-", ""),
                          status: UserStatus.normal,
                          borrowingBookList: [],
                          borrowedHistoryList: [],
                        );
                        userService.add(user);

                        Navigator.pop(context);
                      } else {
                        userService.add(User.empty());
                        Navigator.pop(context);
                        // // ignore: deprecated_member_use
                        // Scaffold.of(context).hideCurrentSnackBar();
                        // // ignore: deprecated_member_use
                        // Scaffold.of(context).showSnackBar(
                        //   SnackBar(
                        //     content:
                        //         Text("Nhập dữ liệu sai, vui lòng nhập lại"),
                        //     behavior: SnackBarBehavior.fixed,
                        //     // margin: EdgeInsets.only(
                        //     //   left: Insets.m,
                        //     //   right: Insets.m,
                        //     //   bottom: 2 * Insets.m + 50,
                        //     // ),
                        //   ),
                        // );
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

  Widget imageField() {
    if (_memoryImg != null)
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              borderRadius: Corners.s5Border,
            ),
            child: Image.memory(
              _memoryImg,
              width: PageBreak.defaultPB.isMobile(context)
                  ? MediaQuery.of(context).size.width
                  : imageHeight,
              height: imageHeight,
              fit: BoxFit.cover,
            ).clipRRect(all: Corners.s5),
          ),
          Align(
            alignment: Alignment.topRight,
            child: MouseRegion(
                onEnter: (_) => setState(() => _hover = !_hover),
                onExit: (_) => setState(() => _hover = !_hover),
                child: GestureDetector(
                  onTap: () => setState(() => _memoryImg = null),
                  child: Container(
                    margin: EdgeInsets.all(Insets.sm),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(_hover ? 1.0 : 0.4),
                      borderRadius: Corners.s5Border,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                )),
          ),
        ],
      )
          .constrained(
            height: imageHeight,
            width: PageBreak.defaultPB.isMobile(context)
                ? MediaQuery.of(context).size.width
                : imageHeight,
          )
          .paddingOnly(
            right: Insets.m,
            bottom: PageBreak.defaultPB.isMobile(context) ? Insets.m : 0.0,
          );

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _disableColor = Theme.of(context).primaryColor.withOpacity(0.5);
        });
      },
      onExit: (_) {
        setState(() {
          _disableColor = Theme.of(context).disabledColor.withOpacity(0.5);
        });
      },
      child: DottedBorder(
        radius: Corners.s10Radius,
        borderType: BorderType.RRect,
        dashPattern: [Insets.sm],
        color: _disableColor ?? Theme.of(context).disabledColor,
        child: Container(
          width: PageBreak.defaultPB.isMobile(context)
              ? MediaQuery.of(context).size.width
              : imageHeight - 2.0,
          height: imageHeight - 2.0,
          child: Stack(
            children: [
              Container(
                width: PageBreak.defaultPB.isMobile(context)
                    ? MediaQuery.of(context).size.width
                    : imageHeight - 2.0,
                height: imageHeight - 2.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...((PageBreak.defaultPB.isMobile(context))
                        ? [
                            IconButton(
                              icon: Icon(Entypo.camera),
                              iconSize: 40.0,
                              color: _disableColor ??
                                  Theme.of(context).disabledColor,
                              onPressed: () async {
                                _memoryImg = await FileUtils.image();
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(Entypo.image),
                              iconSize: 40.0,
                              color: _disableColor ??
                                  Theme.of(context).disabledColor,
                              onPressed: () {},
                            ),
                          ]
                        : [
                            IconButton(
                              icon: Icon(Entypo.image),
                              iconSize: 80.0,
                              color: _disableColor ??
                                  Theme.of(context).disabledColor,
                              onPressed: () async {
                                _memoryImg = await FileUtils.image();
                                setState(() {});
                              },
                            ),
                          ]),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: Durations.fast,
                  curve: Curves.decelerate,
                  height: _showImageError ? 48.0 : 0.0,
                  width: imageHeight - Insets.m,
                  margin: EdgeInsets.only(bottom: Insets.sm),
                  decoration: BoxDecoration(
                    borderRadius: Corners.s5Border,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Không được bỏ trống",
                    style: Theme.of(context).snackBarTheme.contentTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ).paddingOnly(
          right: Insets.m,
          bottom: PageBreak.defaultPB.isMobile(context) ? Insets.m : 0.0),
    );
  }

  Widget dataField() => Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Theme(
            data: Theme.of(context)
                .copyWith(accentColor: Theme.of(context).primaryColor),
            child: Container(
              padding: EdgeInsets.only(right: Insets.m),
              child: Column(
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
                    validator: _identityCardValidator,
                    keyboardType: TextInputType.numberWithOptions(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
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
                    controller: _currentClassController,
                    validator: _currentClassValidator,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: "Niên khóa",
                      hintText: "VD: A6-K74",
                    ),
                  ),
                  VSpace(Insets.m),
                  TextFormField(
                    controller: _phoneController,
                    validator: _phoneValidator,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      PhoneFormatter(),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      labelText: "Số điện thoại",
                      prefixIcon: TextButton(
                        child: Text("+84"),
                        onPressed: () {},
                      )
                          .constrained(width: 50.0)
                          .padding(bottom: 3.0, horizontal: Insets.sm),
                    ),
                  ),
                  VSpace(1.0),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        elevation: 3.0,
        child: Container(
          height: dialogHeight,
          constraints: BoxConstraints(
            maxHeight: dialogHeight,
            maxWidth: dialogWidth,
          ),
          color: Colors.white,
          child: Scaffold(
            appBar: _appBar(context),
            body: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (PageBreak.defaultPB.isMobile(context))
                      ? Column(
                          children: [
                            imageField(),
                            SizedBox(
                              width: textFieldWidth,
                              child: dataField(),
                            )
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imageField(),
                            SizedBox(
                              height: imageHeight + 3,
                              width: textFieldWidth,
                              child: dataField(),
                            ),
                          ],
                        ),
                  _buildActionButton(padding: EdgeInsets.zero),
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

  AppBar _appBar(BuildContext context) {
    return AppBar(
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
    );
  }
}
