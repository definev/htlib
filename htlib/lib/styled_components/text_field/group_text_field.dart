import 'dart:async';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/modules/dialogs/add_borrowing_history_dialog/controllers/add_borrowing_history_dialog_controller.dart';
import 'package:htlib/styled_components/buttons/base_styled_button.dart';
import 'package:htlib/styled_components/buttons/colored_icon_button.dart';
import 'package:htlib/styled_components/buttons/primary_btn.dart';
import 'package:htlib/styled_components/styled_container.dart';
import 'package:htlib/styled_components/text_field/group_text_field_chip.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:get/get.dart';

class GroupTextField extends StatefulWidget {
  final bool openSearch;
  final List<String> isbnList;
  final Function(List<String> newIsbnList) onChangeIsbnList;

  const GroupTextField(
      {Key key,
      @required this.isbnList,
      this.onChangeIsbnList,
      this.openSearch = false})
      : super(key: key);

  @override
  _GroupTextFieldState createState() => _GroupTextFieldState();
}

class _GroupTextFieldState extends State<GroupTextField> {
  AppTheme theme = Get.find<Rx<AppTheme>>().value;
  FocusNode focusNode = FocusNode();

  double searchBarWidth = 0.0;

  Offset offset = Offset(0.0, 0.0);
  GlobalKey _searchTextField = GlobalKey();
  TextEditingController controller = TextEditingController();

  AddBorrowingHistoryDialogController _controller = Get.find();
  List<BookBase> _bookBase = [];

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
    offset = renderBox?.localToGlobal(Offset.zero) ?? Offset(0.0, 0.0);
    BuildUtils.getFutureSizeFromGlobalKey(_searchTextField, (size) {
      if (size.width != searchBarWidth) {
        print("RELOAD");
        Future.microtask(() => setState(() => searchBarWidth = size.width));
      }
    });

    scheduleMicrotask(() => setState(() {}));
  }

  void onSearchBook(String value) {
    value = value.trim();
    if (value == "") {
      _bookBase = [];
    } else {
      _bookBase = _controller.bookBaseList.where(
        (element) {
          if (element.quantity == 0) return false;
          value = removeDiacritics(value.toLowerCase());
          if (element.isbn.contains(value)) return true;
          if (removeDiacritics(element.name.toLowerCase()).contains(value))
            return true;
          return false;
        },
      ).toList();
    }

    setState(() {});
  }

  double get height {
    if (controller.text.trim() == "") {
      return 48.0;
    }
    if (_bookBase.isNotEmpty) {
      return 48.0 + (_bookBase.length < 6 ? _bookBase.length : 5) * 65;
    } else {
      return 48.0 + 65;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => getSize(context));
    return Row(
      children: [
        BuildUtils.specifyForMobile(
          context,
          defaultValue: PrimaryBtn(
            onPressed: () {},
            child: TextStyles.T1Text("Mã ISBN"),
          ).constrained(width: 130, height: 48).paddingOnly(right: 20),
          mobile: Tooltip(
            child: PrimaryBtn(
              onPressed: () {},
              child: Icon(
                Icons.book,
                color: Colors.white,
              ),
            ),
            message: "Điền mã ISBN",
            textStyle: TextStyles.Body3,
          ).constrained(height: 48, width: 48).paddingOnly(right: Insets.m),
        ),
        Expanded(
          key: _searchTextField,
          child: PortalEntry(
            visible: true,
            portal: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: controller.text == ""
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.9),
                    borderRadius: Corners.s8Border,
                  ),
                  width: searchBarWidth,
                  height: height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            HSpace(widget.isbnList.isNotEmpty ? Insets.sm : 0),
                            ...widget.isbnList.map(
                              (e) => GroupTextFieldChip(
                                text: e,
                                onTap: () {},
                                onClear: () {
                                  List<String> _list = widget.isbnList;
                                  _list.removeAt(
                                      _list.indexWhere((isbn) => isbn == e));
                                  widget.onChangeIsbnList(_list);
                                },
                              ).padding(right: Insets.sm),
                            ),
                            TextFormField(
                              focusNode: focusNode,
                              controller: controller,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nhập mã sách (ISBN)",
                                hintStyle:
                                    TextStyles.Body1.textColor(Colors.black54),
                              ),
                              onChanged: onSearchBook,
                            )
                                .center()
                                .constrained(
                                  animate: true,
                                  maxWidth: 300,
                                  height: 47 - (focusNode.hasFocus ? 2.0 : 0.5),
                                )
                                .animate(Durations.fastest, Curves.easeIn),
                          ],
                        ),
                      ),
                      TweenAnimationBuilder(
                        duration: Durations.fastest,
                        curve: Curves.easeIn,
                        tween: Tween<double>(
                            begin: 0.0, end: focusNode.hasFocus ? 1.0 : 0.0),
                        builder: (context, value, child) => Container(
                          alignment: Alignment.bottomLeft,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 0.5 + value * 1.5,
                                color: Color.lerp(
                                    Colors.black, theme.accent1, value),
                              ),
                            ),
                          ),
                          width: searchBarWidth,
                        ),
                      ),
                      Expanded(
                        child: controller.text.trim() == ""
                            ? SizedBox()
                            : _bookBase.isEmpty
                                ? Center(
                                    child: TextStyles.H2Text(
                                      "Không tìm thấy sách",
                                      color: Colors.black,
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _bookBase.length,
                                    itemBuilder: (context, index) {
                                      return BookTile(
                                        leading: Icon(Feather.book),
                                        title: TextStyles.T1Text(
                                            _bookBase[index].name,
                                            color: Colors.black),
                                        subtitle: TextStyles.Body2Text(
                                            _bookBase[index].price.toString(),
                                            color: Colors.black),
                                        onTap: () {
                                          List<String> _list = widget.isbnList;
                                          _list.add(_bookBase[index].isbn);
                                          widget.onChangeIsbnList(_list);
                                          controller.clear();
                                          focusNode.requestFocus();
                                          setState(() {});
                                        },
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ).positioned(
                    left: BuildUtils.specifyForMobile(context,
                            defaultValue: 150, mobile: 48 + Insets.m) +
                        offset.dx,
                    top: offset.dy),
              ],
            ).constrained(height: context.height, width: context.width),
            child: Container(),
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
