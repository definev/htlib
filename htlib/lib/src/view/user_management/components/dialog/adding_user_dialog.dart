import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
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
import 'package:htlib/_internal/image_whisperer.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/utils/painter/logo.dart';
import 'package:htlib/styles.dart';
import 'package:image_picker/image_picker.dart';
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
  ImageFile _imageFile;
  dynamic _image;
  Color _disableColor;
  bool _hover = false;
  bool _showImageError = false;

  TextEditingController _identityCardController = TextEditingController();
  FocusNode _identityNode = FocusNode();
  String _identityCardValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống số chứng minh nhân dân";

    return null;
  }

  TextEditingController _nameController = TextEditingController();
  FocusNode _nameNode = FocusNode();
  String _nameValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống họ và tên";

    return null;
  }

  TextEditingController _phoneController = TextEditingController();
  FocusNode _phoneNode = FocusNode();
  String _phoneValidator(String value) {
    if (value.isEmpty) return "Không được bỏ trống số điện thoại";
    return null;
  }

  TextEditingController _currentClassController = TextEditingController();
  FocusNode _currentClassNode = FocusNode();
  String _currentClassValidator(String value) {
    return null;
  }

  void imagePicker(ImageSource source) async {
    _imageFile = await FileUtils.image(source);
    if (kIsWeb) {
      var blobImg =
          BlobImage(_imageFile.webImage, name: _imageFile.webImage.name);
      _image = CachedNetworkImageProvider(blobImg.url);
    } else {
      var memory = await _imageFile.image.readAsBytes();
      _image = MemoryImage(memory);
    }
    setState(() {});
  }

  double get imageHeight => 230.0;
  double get dataHeight => 4 * (56.0 + Insets.m) + 9;
  double get dialogHeight => PageBreak.defaultPB.isMobile(context)
      ? MediaQuery.of(context).size.height
      : 6 * (59.0 + Insets.m);
  double get dialogWidth => PageBreak.defaultPB.isDesktop(context)
      ? 1100.0
      : PageBreak.defaultPB.isTablet(context)
          ? PageBreak.defaultPB.mobile
          : MediaQuery.of(context).size.width;
  double get textFieldWidth => PageBreak.defaultPB.isDesktop(context)
      ? 1100.0 - 234.0 - 2 * Insets.m
      : PageBreak.defaultPB.isTablet(context)
          ? PageBreak.defaultPB.mobile - 234.0 - 2 * Insets.m
          : MediaQuery.of(context).size.width;

  Widget _buildActionButton({EdgeInsets padding}) => Padding(
        padding: padding ?? EdgeInsets.only(bottom: Insets.m, right: Insets.m),
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
                    onPressed: () async {
                      if (_imageFile == null) {
                        if (mounted) setState(() => _showImageError = true);
                        Future.delayed(4.seconds + 0.3.seconds, () {
                          if (mounted) setState(() => _showImageError = false);
                        });
                      }
                      if (_imageFile != null &&
                          _formKey.currentState.validate() == true) {
                        User user = User(
                          id: Uuid().v4(),
                          name: _nameController.text,
                          idNumberCard: _identityCardController.text,
                          currentClass:
                              _currentClassController.text.replaceAll("-", ""),
                          phone: _phoneController.text.replaceAll("-", ""),
                          status: UserStatus.normal,
                          bookList: [],
                          borrowedHistoryList: [],
                        );

                        showModal(
                          context: context,
                          builder: (_) => LogoIndicator().center(),
                        );

                        await userService.addAsync(_imageFile, user);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).hideCurrentSnackBar();
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Nhập dữ liệu sai, vui lòng nhập lại"),
                            behavior: SnackBarBehavior.fixed,
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

  Widget imageField() {
    if (_imageFile != null && _image != null)
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              borderRadius: Corners.s5Border,
            ),
            height: dataHeight,
            child: Image(
              image: _image,
              width: PageBreak.defaultPB.isMobile(context)
                  ? MediaQuery.of(context).size.width
                  : imageHeight,
              height: dataHeight,
              fit: BoxFit.cover,
            ).clipRRect(all: Corners.s5),
          ),
          Align(
            alignment: Alignment.topRight,
            child: MouseRegion(
                onEnter: (_) => setState(() => _hover = !_hover),
                onExit: (_) => setState(() => _hover = !_hover),
                child: GestureDetector(
                  onTap: () => setState(() => _imageFile = null),
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
            height: PageBreak.defaultPB.isDesktop(context)
                ? dataHeight
                : imageHeight,
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
              : imageHeight,
          height: dataHeight - 4.0,
          child: Stack(
            children: [
              Container(
                width: PageBreak.defaultPB.isMobile(context)
                    ? MediaQuery.of(context).size.width
                    : imageHeight,
                height: dataHeight - 4.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...((GetPlatform.isMobile)
                        ? [
                            IconButton(
                              icon: Icon(Entypo.camera),
                              iconSize: 40.0,
                              color: _disableColor ??
                                  Theme.of(context).disabledColor,
                              onPressed: () => imagePicker(ImageSource.camera),
                            ),
                            IconButton(
                              icon: Icon(Entypo.image),
                              iconSize: 40.0,
                              color: _disableColor ??
                                  Theme.of(context).disabledColor,
                              onPressed: () => imagePicker(ImageSource.gallery),
                            ),
                          ]
                        : [
                            IconButton(
                              icon: Icon(Entypo.image),
                              iconSize: 80.0,
                              color: _disableColor ??
                                  Theme.of(context).disabledColor,
                              onPressed: () => imagePicker(ImageSource.gallery),
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

  Widget dataField() => Form(
        key: _formKey,
        child: Scrollbar(
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
                      focusNode: _nameNode,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_identityNode),
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Họ và tên",
                      ),
                    ),
                    VSpace(Insets.m),
                    TextFormField(
                      controller: _identityCardController,
                      validator: _identityCardValidator,
                      focusNode: _identityNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_currentClassNode),
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
                      focusNode: _currentClassNode,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_phoneNode),
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
                      focusNode: _phoneNode,
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (PageBreak.defaultPB.isMobile(context)) imageField(),
                if (PageBreak.defaultPB.isMobile(context))
                  dataField().expanded(),
                if (!PageBreak.defaultPB.isMobile(context))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imageField().expanded(),
                      SizedBox(
                        height: dataHeight,
                        width: textFieldWidth,
                        child: dataField(),
                      ),
                    ],
                  ),
                _buildActionButton(
                  padding: EdgeInsets.only(
                      top: Insets.m, bottom: Insets.m, right: Insets.m),
                ),
              ],
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
