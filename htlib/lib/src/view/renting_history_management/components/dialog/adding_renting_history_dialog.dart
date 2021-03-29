import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
import 'package:htlib/src/view/renting_history_management/components/dialog/widgets/date_picker_widget.dart';
import 'package:htlib/src/view/renting_history_management/components/dialog/widgets/user_field.dart';
import 'package:htlib/styles.dart';
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
  Map<String, int> _bookMap = {};
  List<String> _bookNameList = [];

  List<bool> _toggleButton = [true, false];

  bool _userError = false;
  bool _endAtError = false;
  User _user;

  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  int moneyTotal = 0;

  TextEditingController _searchUserController = TextEditingController();
  TextEditingController _searchBookController = TextEditingController();

  StreamSubscription<User> _userScanStreamSubscription;
  StreamSubscription<Book> _bookScanStreamSubscription;

  double get dataHeight => 4 * (56.0 + Insets.m) + 9;
  double get dialogHeight => PageBreak.defaultPB.isMobile(context)
      ? MediaQuery.of(context).size.height
      : 7 * (59.0 + Insets.m) - 28;
  double get dialogWidth => PageBreak.defaultPB.isDesktop(context)
      ? 1100.0
      : PageBreak.defaultPB.isTablet(context)
          ? PageBreak.defaultPB.tablet
          : MediaQuery.of(context).size.width;

  Widget _buildActionButton() => SizedBox(
        height: 53.0,
        child: Row(
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
                        4.3.seconds,
                        () => setState(() => _userError = false),
                      );

                      isError = true;
                    }
                    if (_endAt == null) {
                      _endAtError = true;
                      _searchUserController.clear();
                      setState(() {});

                      Future.delayed(
                        4.3.seconds,
                        () => setState(() => _endAtError = false),
                      );

                      isError = true;
                    }

                    if (_bookMap.isEmpty) {
                      isError = true;
                      // ignore: deprecated_member_use
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Chưa thêm sách nào"),
                        ),
                      );

                      Future.delayed(
                        4.3.seconds,
                        () => setState(() => _endAtError = false),
                      );
                    }

                    if (!isError) {
                      var uuid = Uuid();
                      RentingHistory rentingHistory = RentingHistory(
                        id: uuid.v4(),
                        createAt: DateTime.now(),
                        endAt: _endAt,
                        bookMap: _bookMap,
                        state: RentingHistoryStateCode.renting.index,
                        borrowBy: _user.id,
                        total: moneyTotal,
                      );
                      await rentingHistoryService.addAsync(
                        rentingHistory,
                        user: _user,
                        bookMap: _bookMap,
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

  bool addBook(Book book, {Function() onAdd}) {
    if (book == null) return false;
    if (book.quantity >= 1) {
      book = book.copyWith(quantity: book.quantity - 1);
      int i = _allBookList.indexWhere((b) => b.isbn == book.isbn);
      _allBookList[i] = book;
      _bookMap[book.isbn] = (_bookMap[book.isbn] ?? 0) + 1;
      _bookNameList.add(book.name);
      if (_bookDataList.where((e) => e.isbn == book.isbn).isEmpty) {
        _bookDataList.add(book);
      }

      moneyTotal += book.price;
      onAdd?.call();
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  bool removeBook(Book book) {
    if (book == null) return false;
    _bookMap[book.isbn]--;
    if (_bookMap[book.isbn] == 0) {
      _bookDataList.remove(book);
      _bookMap.remove(book.isbn);
    }
    var bookIndex = _allBookList.indexWhere((e) => e.isbn == book.isbn);
    _allBookList[bookIndex] = _allBookList[bookIndex]
        .copyWith(quantity: _allBookList[bookIndex].quantity + 1);

    _searchBookList = bookService.search(
      _searchBookController.text,
      src: _allBookList,
    );
    moneyTotal -= book.price;
    setState(() {});
    return true;
  }

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
                    enableEdited: false,
                    onTap: () {
                      Book book = _searchBookList[index];

                      addBook(book, onAdd: () {
                        _searchBookController.clear();
                        _searchBookList = [];
                      });
                    },
                  ),
                ),
        ).expanded(),
      ],
    );
  }

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
                int quantity = _bookMap[_bookDataList[index].isbn];
                Book _book = _bookDataList[index];

                return BookListTile(
                  _book.copyWith(quantity: quantity),
                  enableEdited: false,
                  countMode: CountMode(
                    add: (quantity) => addBook(
                      _book,
                      onAdd: () {
                        _searchBookList = bookService.search(
                          _searchBookController.text,
                          src: _allBookList,
                        );
                      },
                    ),
                    remove: (quantity) => removeBook(_book),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 46,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Giá trị"),
                Text(
                  "${StringUtils.moneyFormat(moneyTotal)} VND",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ).paddingSymmetric(horizontal: Insets.mid),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userService.api.user.onSearchDone();
    bookService.api.book.onSearchDone();
    _allBookList = bookService.getList();
    _userScanStreamSubscription =
        userService.api.user.searchStream().listen((user) {
      setState(() => _user = user);
    });

    _bookScanStreamSubscription =
        userService.api.book.searchStream().listen((book) {
      if (book != null) {
        int i = _allBookList.indexWhere((b) => b.isbn == book.isbn);
        addBook(_allBookList[i]);
      }
    });
  }

  @override
  void dispose() {
    _userScanStreamSubscription.cancel();
    _bookScanStreamSubscription.cancel();
    userService.api.user.onSearchDone();
    bookService.api.book.onSearchDone();
    super.dispose();
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
                                Column(
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(() =>
                                            _toggleButton = [true, false]);
                                      },
                                      style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                            Size(64.0, 56.0)),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                          _toggleButton[0]
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context).disabledColor,
                                        ),
                                      ),
                                      child: Icon(Feather.user),
                                    ),
                                    VSpace(Insets.sm),
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(() =>
                                            _toggleButton = [false, true]);
                                      },
                                      style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                            Size(64.0, 56.0)),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                          _toggleButton[1]
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context).disabledColor,
                                        ),
                                      ),
                                      child: Icon(Feather.user),
                                    ),
                                  ],
                                ),
                                HSpace(Insets.m),
                                _toggleButton[0]
                                    ? UserField(
                                        controller: _searchUserController,
                                        user: _user,
                                        nullUser: _userError,
                                        nullDate: _endAtError,
                                        searchUserList: _searchUserList,
                                        onSearch: (users) {
                                          setState(
                                              () => _searchUserList = users);
                                        },
                                        onRemoveUser: () {
                                          setState(() => _user = null);
                                        },
                                        onSelectUser: (user) =>
                                            setState(() => _user = user),
                                      ).expanded()
                                    : dataField().expanded(),
                              ],
                            ).constrained(
                              height: dataHeight,
                              width: double.maxFinite,
                            ),
                            DatePickerWidget(
                              dateTime: _endAt,
                              onPickDateTime: (endAt) {
                                setState(() => _endAt = endAt);
                              },
                            ),
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
                            UserField(
                              datePickerWidget: DatePickerWidget(
                                dateTime: _endAt,
                                onPickDateTime: (endAt) {
                                  setState(() => _endAt = endAt);
                                },
                              ),
                              controller: _searchUserController,
                              user: _user,
                              nullUser: _userError,
                              nullDate: _endAtError,
                              searchUserList: _searchUserList,
                              onSearch: (users) {
                                setState(() => _searchUserList = users);
                              },
                              onRemoveUser: () {
                                setState(() => _user = null);
                              },
                              onSelectUser: (user) =>
                                  setState(() => _user = user),
                            ).constrained(width: 250),
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
