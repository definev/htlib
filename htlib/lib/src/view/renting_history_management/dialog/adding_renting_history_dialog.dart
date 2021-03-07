import 'package:cached_network_image/cached_network_image.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/view/book_management/components/book_list_tile.dart';
import 'package:htlib/src/view/user_management/components/user_list_tile.dart';
import 'package:htlib/styles.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:htlib/_internal/utils/build_utils.dart';

class AddingRentingHistoryDialog extends StatefulWidget {
  @override
  _AddingRentingHistoryDialogState createState() =>
      _AddingRentingHistoryDialogState();
}

class _AddingRentingHistoryDialogState
    extends State<AddingRentingHistoryDialog> {
  RentingHistoryService rentingHistoryService = Get.find();
  BookService bookService = Get.find();
  UserService userService = Get.find();

  List<Book> _bookList = [];
  List<Book> _searchBookList = [];

  List<User> _searchUserList = [];

  DateTime _endAt;
  List<String> _isbnList = [];
  List<String> _nameList = [];

  Color _disableColor;
  bool _userError = false;
  bool _endAtError = false;
  User _user;

  CrossFadeState _fadeState = CrossFadeState.showFirst;

  TextEditingController _searchUserController = TextEditingController();
  TextEditingController _searchBookController = TextEditingController();

  double get imageHeight => 250;
  double get dataHeight => 4 * (56.0 + Insets.m) + 9;
  double get dialogHeight => PageBreak.defaultPB.isMobile(context)
      ? MediaQuery.of(context).size.height
      : 7 * (59.0 + Insets.m) - 28;
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

  Widget _buildChip(String label, int index, {bool last = false}) {
    return Align(
      alignment: Alignment.topCenter,
      child: Chip(
        labelPadding: EdgeInsets.all(2.0),
        avatar: CircleAvatar(
          backgroundColor: Colors.white70,
          child: Icon(Icons.menu_book, size: 13),
        ),
        label: Text(
          "  $label  ",
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Theme.of(context).colorScheme.onSecondary),
        ),
        elevation: 2.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        padding: EdgeInsets.all(8.0),
        deleteIcon: Icon(Icons.close, size: 13),
        deleteIconColor: Theme.of(context).colorScheme.onSecondary,
        onDeleted: () {
          int i = _bookList.indexWhere((b) => b.isbn == _isbnList[index]);

          _bookList[i] =
              _bookList[i].copyWith(quantity: _bookList[i].quantity + 1);

          _isbnList.removeAt(index);
          _nameList.removeAt(index);

          _searchBookList = bookService.search(
            _searchBookController.text,
            src: _bookList,
            checkEmpty: true,
          );

          setState(() {});
        },
      ).paddingOnly(right: last ? 0.0 : Insets.sm),
    );
  }

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
                      bool isError = false;

                      if (_user == null) {
                        _userError = true;
                        setState(() {});

                        Future.delayed(
                          4.seconds,
                          () => setState(() => _userError = false),
                        );

                        isError = true;
                      }
                      if (_endAt == null) {
                        _endAtError = true;
                        setState(() {});

                        Future.delayed(
                          4.seconds,
                          () => setState(() => _endAtError = false),
                        );

                        isError = true;
                      }

                      if (!isError) {
                        var uuid = Uuid();
                        RentingHistory rentingHistory = RentingHistory(
                          id: uuid.v4(),
                          createAt: DateTime.now(),
                          endAt: _endAt,
                          isbnList: _isbnList,
                          state: RentingHistoryStateCode.renting.index,
                          borrowBy: _user.id,
                        );
                        rentingHistoryService.add(rentingHistory);

                        Navigator.pop(context);
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

  Widget dataField() {
    return Container(
      padding: EdgeInsets.only(right: Insets.m),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (_nameList.isNotEmpty)
            ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                _nameList.length,
                (index) => _buildChip(_nameList[index], index,
                    last: _nameList.length - 1 == index),
              ),
            ).constrained(height: 32 + Insets.m, width: double.maxFinite),
          TextField(
            controller: _searchBookController,
            decoration: InputDecoration(hintText: "Tìm kiếm sách"),
            onChanged: (query) {
              _searchBookList = bookService.search(query, src: _bookList);
              setState(() {});
            },
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).tileColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(5.0)),
            ),
            margin: EdgeInsets.only(top: Insets.m),
            child: _searchBookList.isEmpty
                ? Center(
                    child: Text("Không tìm thấy sách",
                        style: Theme.of(context).textTheme.headline6))
                : ListView.builder(
                    itemCount: _searchBookList.length,
                    itemBuilder: (context, index) => BookListTile(
                      _searchBookList[index],
                      onTap: () {
                        Book book = _searchBookList[index];

                        if (book.quantity >= 1) {
                          book = book.copyWith(quantity: book.quantity - 1);
                          int i =
                              _bookList.indexWhere((b) => b.isbn == book.isbn);
                          _bookList[i] = book;
                          _isbnList.add(book.isbn);
                          _nameList.add(book.name);

                          setState(() {
                            _searchBookController.clear();
                            _searchBookList = [];
                          });
                        }
                      },
                    ),
                  ),
          ).expanded(),
        ],
      ),
    );
  }

  Widget userField([bool isMobile = false]) => SizedBox(
        width: imageHeight,
        child: Column(
          children: [
            Stack(
              children: [
                AnimatedCrossFade(
                  duration: Durations.medium,
                  crossFadeState: _fadeState,
                  firstChild: DottedBorder(
                    radius: Corners.s8Radius,
                    borderType: BorderType.RRect,
                    strokeWidth: 3,
                    dashPattern: [Insets.sm],
                    color: _disableColor ?? Theme.of(context).disabledColor,
                    child: Container(
                      width: PageBreak.defaultPB.isMobile(context)
                          ? MediaQuery.of(context).size.width
                          : imageHeight,
                      height: dataHeight - 4.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.supervised_user_circle_outlined),
                            iconSize: 80.0,
                            color: _disableColor ??
                                Theme.of(context).disabledColor,
                            onPressed: () {
                              setState(() {
                                _fadeState = CrossFadeState.showSecond;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  secondChild: AnimatedCrossFade(
                    duration: Durations.medium,
                    crossFadeState: _user == null
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Container(
                      width: PageBreak.defaultPB.isMobile(context)
                          ? MediaQuery.of(context).size.width
                          : imageHeight,
                      height: dataHeight - 4.0,
                      decoration: BoxDecoration(borderRadius: Corners.s5Border),
                      child: Column(
                        children: [
                          TextField(
                            controller: _searchUserController,
                            decoration:
                                InputDecoration(hintText: "Tìm người mượn"),
                            onChanged: (query) {
                              _searchUserList = userService.search(query);
                              setState(() {});
                            },
                          ),
                          VSpace(2.0),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Corners.s5Radius),
                                color: Theme.of(context).tileColor,
                              ),
                              child: _searchUserList.isEmpty
                                  ? Center(
                                      child: Text(
                                        "Không tìm thấy \n người mượn",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(height: 1.4),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : ListView.builder(
                                      itemBuilder: (context, index) =>
                                          UserListTile(
                                        _searchUserList[index],
                                        isSmall: true,
                                        onTap: () {
                                          setState(() {
                                            _user = _searchUserList[index];
                                          });
                                        },
                                      ),
                                      itemCount: _searchUserList.length,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    secondChild: _user == null
                        ? Container()
                        : Image(
                            image: CachedNetworkImageProvider(_user.imageUrl),
                            fit: BoxFit.cover,
                            height: double.maxFinite,
                            width: double.maxFinite,
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedContainer(
                    duration: Durations.fast,
                    curve: Curves.decelerate,
                    height: _userError == true ? 48.0 : 0.0,
                    width: imageHeight - Insets.m,
                    margin: EdgeInsets.only(top: isMobile ? 0.0 : Insets.sm),
                    decoration: BoxDecoration(
                      borderRadius: Corners.s5Border,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Không được bỏ trống người dùng",
                      style: Theme.of(context).snackBarTheme.contentTextStyle,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: Durations.fast,
                    curve: Curves.decelerate,
                    height: _endAtError == true ? 48.0 : 0.0,
                    width: imageHeight - Insets.m,
                    margin: EdgeInsets.only(bottom: Insets.sm),
                    decoration: BoxDecoration(
                      borderRadius: Corners.s5Border,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Không được bỏ trống hạn mượn",
                      style: Theme.of(context).snackBarTheme.contentTextStyle,
                    ),
                  ),
                ),
              ],
            ).constrained(height: dataHeight - 4.0),
            VSpace(Insets.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    _endAt = await showDatePicker(
                      context: context,
                      firstDate: now.add(1.days),
                      lastDate: now.add(60.days),
                      initialDate: now.add(1.days),
                    );
                    setState(() {});
                  },
                ).constrained(width: 56),
                Padding(
                  padding: EdgeInsets.only(
                      right: _endAt == null ? 2 * Insets.sm + 2 : 0),
                  child: Text(
                      "${_endAt == null ? "Hạn mượn" : DateFormat("dd/MM/yyyy").format(_endAt)}"),
                ),
                if (_endAt != null)
                  ElevatedButton(
                    child: Text("Xóa"),
                    onPressed: () async {
                      _endAt = null;
                      setState(() {});
                    },
                  )
                      .paddingOnly(right: 2 * Insets.sm + 2)
                      .constrained(width: 56),
              ],
            ).paddingSymmetric(vertical: isMobile ? Insets.m : 0.0),
          ],
        ),
      ).paddingOnly(right: isMobile ? Insets.m : 0);

  @override
  void initState() {
    super.initState();
    _bookList = bookService.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(accentColor: Theme.of(context).primaryColor),
      child: Align(
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
                  PageBreak.defaultPB.isMobile(context)
                      ? ListView(
                          children: [
                            userField(true),
                            HSpace(Insets.m),
                            SizedBox(
                              height: 400.0,
                              width: MediaQuery.of(context).size.width -
                                  2 * Insets.m,
                              child: dataField(),
                            ),
                          ],
                        ).expanded()
                      : Row(
                          children: [
                            userField(),
                            HSpace(Insets.m),
                            dataField().expanded(),
                          ],
                        ).expanded(),
                  if (PageBreak.defaultPB.isMobile(context)) VSpace(Insets.m),
                  _buildActionButton(padding: EdgeInsets.zero),
                ],
              ).padding(
                top: Insets.m,
                left: Insets.m,
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Thêm đơn mượn sách",
        style: Theme.of(context).textTheme.headline6.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    );
  }
}
