import 'dart:async';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/app/data/user.dart';
import 'package:htlib/app/modules/dialogs/add_borrowing_history_dialog/controllers/add_borrowing_history_dialog_controller.dart';
import 'package:htlib/styled_components/buttons/primary_btn.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:get/get.dart';

class UserTextField extends StatefulWidget {
  final User user;
  final Function(User) onPickUser;
  const UserTextField({Key key, this.user, this.onPickUser}) : super(key: key);

  @override
  _UserTextFieldState createState() => _UserTextFieldState();
}

class _UserTextFieldState extends State<UserTextField> {
  AppTheme theme = Get.find<Rx<AppTheme>>().value;
  FocusNode focusNode = FocusNode();

  double searchBarWidth = 0.0;

  Offset offset = Offset(0.0, 0.0);
  GlobalKey _searchTextField = GlobalKey();
  TextEditingController controller = TextEditingController();

  AddBorrowingHistoryDialogController _borrowingHistoryController = Get.find();
  List<User> _userList = [];

  double get height {
    if (controller.text.trim() == "") {
      return 0.0;
    }
    if (_userList.isNotEmpty) {
      return (_userList.length < 6 ? _userList.length : 5) * 65.0;
    } else {
      return 65;
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  void getSize(BuildContext context) {
    RenderBox renderBox = context.findRenderObject();
    Offset newOffset =
        renderBox?.localToGlobal(Offset.zero) ?? Offset(0.0, 0.0);
    if (newOffset != offset)
      Future.microtask(() => setState(() {
            offset = newOffset;
          }));

    BuildUtils.getFutureSizeFromGlobalKey(_searchTextField, (size) {
      if (size.width != searchBarWidth) {
        Future.microtask(() => setState(() => searchBarWidth = size.width));
      }
    });
  }

  void onSearchUser(String value) {
    value = value.trim();
    if (value == "") {
      _userList = [];
    } else {
      _userList = _borrowingHistoryController.userList.where(
        (user) {
          value = removeDiacritics(value.toLowerCase());
          var name = removeDiacritics(user.name.toLowerCase());
          var currentClass = removeDiacritics(user.currentClass.toLowerCase());
          var phone = removeDiacritics(user.phone.toLowerCase());

          if (name.contains(value)) return true;
          if (currentClass.contains(value)) return true;
          if (phone.contains(value)) return true;
          return false;
        },
      ).toList();
    }

    setState(() {});
  }

  void onClearUser(String e) {}

  void onAddUser(User u) {}

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => getSize(context));
    return Row(
      children: [
        BuildUtils.specifyForMobile(
          context,
          defaultValue: PrimaryBtn(
            onPressed: () {},
            child: TextStyles.T1Text("Người mượn"),
            borderRadius: BorderRadius.only(
              topLeft: Corners.s5Radius,
              bottomLeft: Corners.s5Radius,
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ).constrained(width: 130, height: 48).paddingOnly(right: Insets.mid),
          mobile: Tooltip(
            child: PrimaryBtn(
              onPressed: () {},
              child: Icon(
                Icons.book,
                color: Colors.white,
              ),
            ),
            message: "Điền người mượn",
            textStyle: TextStyles.Body3,
          ).constrained(height: 48, width: 48).paddingOnly(right: Insets.m),
        ),
        Expanded(
          key: _searchTextField,
          child: PortalEntry(
            visible: true,
            portal: TweenAnimationBuilder(
              duration: Durations.fastest,
              curve: Curves.easeIn,
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: child,
              ),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: Durations.medium,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: controller.text.trim() == ""
                          ? null
                          : [
                              BoxShadow(
                                blurRadius: 8,
                                color: theme.accent1.withOpacity(0.2),
                                offset: Offset(0, 3),
                              ),
                            ],
                      border: controller.text.trim() == ""
                          ? null
                          : Border.all(color: theme.accent1, width: 2),
                    ),
                    width: searchBarWidth,
                    height: height,
                    child: controller.text.trim() == ""
                        ? SizedBox()
                        : _userList.isEmpty
                            ? Center(
                                child: TextStyles.H2Text(
                                  "Không tìm thấy người mượn",
                                  color: Colors.black,
                                ),
                              )
                            : ListView.builder(
                                itemCount: _userList.length,
                                itemBuilder: (context, index) {
                                  return BookTile(
                                    leading: Icon(Feather.book),
                                    title: TextStyles.T1Text(
                                        _userList[index].name,
                                        color: Colors.black),
                                    subtitle: TextStyles.Body2Text(
                                        _userList[index].name.toString(),
                                        color: Colors.black),
                                    onTap: () => onAddUser(_userList[index]),
                                  );
                                },
                              ),
                  ).positioned(
                      left: BuildUtils.specifyForMobile(context,
                              defaultValue: 130 + Insets.mid,
                              mobile: 48 + Insets.m) +
                          offset.dx,
                      top: 46 + offset.dy),
                ],
              ).constrained(height: context.height, width: context.width),
            ),
            child: TextFormField(
              focusNode: focusNode,
              controller: controller,
              decoration: InputDecoration(
                hintText: "Tìm người mượn",
                hintStyle: TextStyles.Body1.textColor(Colors.black54),
              ),
              onChanged: onSearchUser,
            ),
          ),
        ),
      ],
    ).constrained(height: 48.0);
  }
}

class BookTile extends StatelessWidget {
  final Function() onTap;
  final Widget leading;
  final Widget title;
  final Widget subtitle;

  const BookTile({Key key, this.onTap, this.leading, this.title, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            children: [
              leading.constrained(height: 63, width: 65),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: Durations.fastest,
                    curve: Curves.easeIn,
                    style: TextStyles.T1,
                    child: title,
                  ),
                  VSpace(Insets.sm),
                  subtitle
                ],
              ).expanded(),
            ],
          ),
          Container(
            height: 1,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: Insets.sm),
            color:
                AppTheme.fromType(ThemeType.BlueHT).greyWeak.withOpacity(0.5),
          ),
        ],
      ),
    ).gestures(onTap: onTap);
  }
}
