import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
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

  List<Book> _allBookList = [];
  List<Book> _searchBookList = [];

  List<User> _searchUserList = [];

  DateTime _endAt;

  List<Book> _bookDataList = [];
  List<String> _bookList = [];
  List<String> _bookNameList = [];

  bool _userError = false;
  bool _endAtError = false;
  User _user;

  int moneyTotal = 0;

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

  Widget _buildActionButton() => SizedBox(
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
                    bool isError = false;

                    if (_user == null) {
                      _userError = true;
                      _searchUserController.clear();
                      _searchUserList = [];
                      setState(() {});

                      Future.delayed(
                        4.seconds,
                        () => setState(() => _userError = false),
                      );

                      isError = true;
                    }
                    if (_endAt == null) {
                      _endAtError = true;
                      _searchUserController.clear();
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
                        bookList: _bookList,
                        state: RentingHistoryStateCode.renting.index,
                        borrowBy: _user.id,
                      );
                      await rentingHistoryService.addAsync(
                        rentingHistory,
                        user: _user,
                        bookList: _bookList,
                        allBookList: _allBookList,
                      );

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
      );

  Widget dataField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextField(
          controller: _searchBookController,
          decoration: InputDecoration(hintText: "Tìm kiếm sách"),
          onChanged: (query) {
            _searchBookList = bookService.search(query, src: _allBookList);
            setState(() {});
          },
        ),
        VSpace(1.0),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).tileColor,
            borderRadius: BorderRadius.vertical(bottom: Corners.s5Radius),
          ),
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
                            _allBookList.indexWhere((b) => b.isbn == book.isbn);
                        _allBookList[i] = book;
                        _bookList.add(book.isbn);
                        _bookNameList.add(book.name);
                        if (_bookDataList
                            .where((e) => e.isbn == book.isbn)
                            .isEmpty) {
                          _bookDataList.add(book);
                        }

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
    );
  }

  Widget userField([bool isMobile = false]) => Column(
        children: [
          Stack(
            children: [
              AnimatedCrossFade(
                duration: Durations.medium,
                crossFadeState: _user == null
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Container(
                  decoration: BoxDecoration(borderRadius: Corners.s5Border),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchUserController,
                        decoration: InputDecoration(hintText: "Tìm người mượn"),
                        onChanged: (query) {
                          _searchUserList = userService.search(query);
                          setState(() {});
                        },
                      ),
                      VSpace(1.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(bottom: Corners.s5Radius),
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
                                  itemBuilder: (context, index) => UserListTile(
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
                    : Stack(
                        children: [
                          Image(
                            // image: AssetImage("assets/images/mock.jpg"),
                            image: CachedNetworkImageProvider(_user.imageUrl),
                            fit: BoxFit.cover,
                            height: double.maxFinite,
                            width: double.maxFinite,
                          ).clipRRect(all: Corners.s5),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.all(14.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                      Size(35.0, 35.0)),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: FontSizes.s14,
                                ),
                                onPressed: () => setState(() => _user = null),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: AnimatedContainer(
                  duration: Durations.fast,
                  curve: Curves.decelerate,
                  height: _userError == true ? 50.0 : 0.0,
                  width: imageHeight - Insets.m,
                  margin: EdgeInsets.only(top: 48.0),
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
          ).expanded(),
          if (!isMobile) _datePickerWidget(),
        ],
      );

  Widget _datePickerWidget() => Column(
        children: [
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
                ).paddingOnly(right: 2 * Insets.sm + 2).constrained(width: 56),
            ],
          ),
        ],
      );

  Widget _bookListWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).tileColor, borderRadius: Corners.s5Border),
      child: Column(
        children: [
          Container(
            height: 49.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Corners.s5Radius)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VSpace(Insets.sm),
                Row(
                  children: [
                    HSpace(Insets.m),
                    Text("Danh sách sách",
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
                Container(height: 2, color: Color(0xFFAFAFB0)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _bookDataList.length,
              itemBuilder: (context, index) {
                int quantity = _bookList
                    .where((e) => e == _bookDataList[index].isbn)
                    .length;
                Book _book = _bookDataList[index];
                _book = _book.copyWith(quantity: quantity);

                return BookListTile(
                  _book,
                  countMode: CountMode(
                    add: (quantity) {
                      var bookMap = bookService.bookListToBookMap(_bookList);
                      bookMap[_book.isbn]++;
                      if (bookMap[_book.isbn] <= 0) {
                        bookMap[_book.isbn] = null;
                      }

                      _bookList = bookService.bookMapToBookList(bookMap);
                      setState(() {});
                    },
                    remove: (quantity) {
                      var bookMap = bookService.bookListToBookMap(_bookList);
                      bookMap[_book.isbn]--;
                      if (bookMap[_book.isbn] <= 0) {
                        bookMap[_book.isbn] = null;
                      }

                      _bookList = bookService.bookMapToBookList(bookMap);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Giá trị"),
                Text("${StringUtils.moneyFormat(moneyTotal)} VND"),
              ],
            ).paddingSymmetric(horizontal: Insets.m),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _allBookList = bookService.getList();
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
                            Row(
                              children: [
                                userField(true).expanded(),
                                HSpace(Insets.m),
                                dataField().expanded(),
                              ],
                            ).constrained(
                              height: dataHeight,
                              width: double.maxFinite,
                            ),
                            _datePickerWidget(),
                            VSpace(Insets.m),
                            SizedBox(
                              height: 400.0,
                              width: MediaQuery.of(context).size.width -
                                  2 * Insets.m,
                              child: _bookListWidget(),
                            ),
                          ],
                        ).expanded()
                      : Row(
                          children: [
                            userField().constrained(width: imageHeight),
                            HSpace(Insets.m),
                            Row(
                              children: [
                                dataField().expanded(),
                                HSpace(Insets.m),
                                _bookListWidget().expanded(),
                              ],
                            ).expanded(),
                          ],
                        ).expanded(),
                  if (PageBreak.defaultPB.isMobile(context)) VSpace(Insets.m),
                  _buildActionButton().padding(top: Insets.m),
                ],
              ).padding(all: Insets.m),
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
