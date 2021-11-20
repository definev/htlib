// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/_internal/utils/utils.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/view/book_management/components/book_list_tile.dart';
import 'package:htlib/src/view/renting_history_management/components/dialog/widgets/date_picker_widget.dart';
import 'package:htlib/src/view/renting_history_management/components/dialog/widgets/user_field.dart';
import 'package:htlib/styles.dart';
import 'package:uuid/uuid.dart';
import 'package:htlib/_internal/styled_widget.dart';
import 'package:htlib/_internal/utils/build_utils.dart';

class AddingRentingHistoryDialog extends StatefulWidget {
  @override
  _AddingRentingHistoryDialogState createState() => _AddingRentingHistoryDialogState();
}

class _AddingRentingHistoryDialogState extends State<AddingRentingHistoryDialog> {
  RentingHistoryService rentingHistoryService = Get.find();
  BookService bookService = Get.find();
  UserService userService = Get.find();

  List<Book> _allBookList = [];
  List<Book> _searchBookList = [];

  List<User> _searchUserList = [];

  DateTime? _endAt;

  List<Book> _bookSelectedList = [];
  Map<String, int> _bookSelectedMap = {};

  List<bool> _toggleButton = [true, false];

  bool _userError = false;
  bool _endAtError = false;
  User? _user;

  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  int moneyTotal = 0;

  AdminService adminService = Get.find();

  TextEditingController _searchUserController = TextEditingController();
  TextEditingController _searchBookController = TextEditingController();

  late StreamSubscription<User?> _userScanStreamSubscription;
  late StreamSubscription<Book?> _bookScanStreamSubscription;

  double get dataHeight => 4 * (56.0 + Insets.m) + 9;
  double get dialogHeight =>
      PageBreak.defaultPB.isMobile(context) ? MediaQuery.of(context).size.height : 7 * (59.0 + Insets.m) - 28;
  double? get dialogWidth => PageBreak.defaultPB.isDesktop(context)
      ? 1100.0
      : PageBreak.defaultPB.isTablet(context)
          ? PageBreak.defaultPB.tablet
          : MediaQuery.of(context).size.width;

  Widget _buildActionButton() {
    return SizedBox(
      height: 53.0,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Hủy".toUpperCase()).bigMode,
            ),
          ),
          HSpace(Insets.sm),
          Expanded(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    bool isError = false;

                    if (_user == null) {
                      _userError = true;
                      _searchUserController.clear();
                      _searchUserList = [];
                      setState(() {});
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Chưa nhập người mượn.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );

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

                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Chưa nhập hạn mượn.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Future.delayed(
                        4.3.seconds,
                        () {
                          if (mounted) {
                            setState(() => _endAtError = false);
                          }
                        },
                      );

                      isError = true;
                    }

                    if (_bookSelectedMap.isEmpty) {
                      isError = true;
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Chưa thêm sách nào"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );

                      Future.delayed(4.3.seconds, () {
                        if (mounted) {
                          setState(() => _endAtError = false);
                        }
                      });
                    }

                    if (!isError) {
                      var uuid = Uuid();
                      RentingHistory rentingHistory = RentingHistory(
                        id: uuid.v4(),
                        createAt: DateTime.now(),
                        endAt: _endAt!,
                        bookMap: _bookSelectedMap,
                        state: RentingHistoryStateCode.renting.index,
                        borrowBy: _user!.id,
                        total: moneyTotal,
                      );
                      await rentingHistoryService.addAsync(
                        rentingHistory,
                        user: _user!,
                        bookMap: _bookSelectedMap,
                        allBookList: _allBookList,
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Thêm".toUpperCase(),
                  ).bigMode,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool addBook(Book book, {required VoidCallback onAddDone}) {
    if (book.quantity >= 1) {
      book = book.copyWith(quantity: book.quantity - 1);
      int i = _allBookList.indexWhere((b) => b.isbn == book.isbn);

      _allBookList[i] = book;

      _bookSelectedMap[book.isbn] = (_bookSelectedMap[book.isbn] ?? 0) + 1;

      int indexOfBook = _bookSelectedList.indexWhere((e) => e.isbn == book.isbn);

      if (indexOfBook == -1) {
        _bookSelectedList.add(book);
      } else {
        _bookSelectedList[indexOfBook] = book;
      }

      moneyTotal += book.price;
      onAddDone.call();
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  bool removeBook(Book? book) {
    if (book == null) return false;
    _bookSelectedMap[book.isbn] = (_bookSelectedMap[book.isbn] ?? 1) - 1;
    if (_bookSelectedMap[book.isbn] == 0) {
      _bookSelectedList.remove(book);
      _bookSelectedMap.remove(book.isbn);
    }

    // All book index
    var bookIndex = _allBookList.indexWhere((e) => e.isbn == book.isbn);
    _allBookList[bookIndex] = _allBookList[bookIndex].copyWith(
      quantity: _allBookList[bookIndex].quantity + 1,
    );

    // Refresh book on search
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
          decoration: InputDecoration(
            hintText: "Tìm kiếm sách",
            suffixIcon: IconButton(
              icon: Icon(Icons.scanner),
              onPressed: _onBookScan,
            ),
          ),
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
              ? Center(child: Text("Không tìm thấy sách"))
              : ListView.builder(
                  itemCount: _searchBookList.length,
                  itemBuilder: (context, index) => BookListTile(
                    _searchBookList[index],
                    enableEdited: false,
                    onTap: () {
                      Book book = _searchBookList[index];

                      addBook(book, onAddDone: () {
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
      decoration: BoxDecoration(color: Theme.of(context).tileColor, borderRadius: Corners.s5Border),
      child: Column(
        children: [
          Container(
            height: 49.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Corners.s5Radius)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VSpace(Insets.sm),
                Row(
                  children: [
                    HSpace(Insets.m),
                    Text("Danh sách sách", style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
                Container(height: 2, color: Color(0xFFAFAFB0)),
              ],
            ),
          ),
          Expanded(
            child: _bookSelectedList.isEmpty
                ? Center(child: Text('Chưa có sách nào.'))
                : ListView.builder(
                    itemCount: _bookSelectedList.length,
                    itemBuilder: (context, index) {
                      int quantity = _bookSelectedMap[_bookSelectedList[index].isbn]!;
                      Book _book = _bookSelectedList[index];

                      return BookListTile(
                        _book.copyWith(quantity: quantity),
                        enableEdited: false,
                        countMode: CountMode(
                          add: (quantity) => addBook(
                            _book,
                            onAddDone: () {
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
    userService.api.student.onSearchDone();
    bookService.api.book.onSearchDone();
    // Get a clone list
    _allBookList = List.from(bookService.getList());
    _userScanStreamSubscription = userService.api.student.searchStream.listen((user) {
      setState(() => _user = user);
    });

    _bookScanStreamSubscription = userService.api.book.searchStream.listen((book) {
      if (book != null) {
        int i = _allBookList.indexWhere((b) => b.isbn == book.isbn);
        addBook(_allBookList[i], onAddDone: () {});
      }
    });
  }

  @override
  void dispose() {
    _userScanStreamSubscription.cancel();
    _bookScanStreamSubscription.cancel();
    userService.api.student.onSearchDone();
    bookService.api.book.onSearchDone();
    super.dispose();
  }

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
            maxWidth: dialogWidth!,
          ),
          color: Colors.white,
          child: Scaffold(
            appBar: _appBar(context),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PageBreak.defaultPB.isMobile(context)
                    ? _mobileLayout(context).expanded()
                    : _largeScreenLayout().expanded(),
                SizedBox(height: 53.0).padding(top: Insets.m),
              ],
            ).padding(all: Insets.m),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: EdgeInsets.all(Insets.m),
              child: _buildActionButton(),
            ),
          ),
        ),
      ),
    );
  }

  void _onUserScan() async {
    String? query = await Utils.scanQrcode(context);
    if (query != null) {
      final userList = userService.search(query);
      if (userList.isNotEmpty) {
        _user = userList.first;
        setState(() {});
      }
    }
  }

  void _onBookScan() async {
    String? query = await Utils.scanQrcode(context);
    if (query != null) {
      final userList = bookService.search(query);
      if (userList.isNotEmpty) {
        addBook(userList.first, onAddDone: () {
          _searchBookController.clear();
          _searchBookList = [];
        });
      }
    }
  }

  Row _largeScreenLayout() {
    return Row(
      children: [
        UserField(
          datePickerWidget: DatePickerWidget(
            dateTime: _endAt,
            onPickDateTime: (endAt) {
              setState(() => _endAt = endAt!);
            },
          ),
          onScanMode: _onUserScan,
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
          onSelectUser: (user) => setState(() => _user = user),
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
    );
  }

  ListView _mobileLayout(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            Column(
              children: [
                OutlinedButton(
                  onPressed: () => setState(() => _toggleButton = [true, false]),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(64.0, 56.0)),
                    side: MaterialStateProperty.all(BorderSide(
                      color: _toggleButton[0]
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor.withOpacity(0.2),
                    )),
                    foregroundColor: MaterialStateProperty.all(
                      _toggleButton[0]
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                  ),
                  child: Icon(Feather.user),
                ),
                VSpace(Insets.sm),
                OutlinedButton(
                  onPressed: () {
                    setState(() => _toggleButton = [false, true]);
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(64.0, 56.0)),
                    side: MaterialStateProperty.all(BorderSide(
                      color: _toggleButton[1]
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor.withOpacity(0.2),
                    )),
                    foregroundColor: MaterialStateProperty.all(
                      _toggleButton[1]
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor.withOpacity(0.2),
                    ),
                  ),
                  child: Icon(Feather.book),
                ),
              ],
            ),
            HSpace(Insets.m),
            IndexedStack(
              index: _toggleButton[0] ? 0 : 1,
              sizing: StackFit.expand,
              children: [
                UserField(
                  controller: _searchUserController,
                  onScanMode: _onUserScan,
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
                  onSelectUser: (user) => setState(() => _user = user),
                ),
                dataField(),
              ],
            ).expanded(),
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
          width: MediaQuery.of(context).size.width - 2 * Insets.m,
          child: _bookListWidget(),
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context) => AppBar(
        title: Text(
          "Thêm đơn mượn sách",
          style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      );
}
