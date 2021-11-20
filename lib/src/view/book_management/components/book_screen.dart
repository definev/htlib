import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/input_formatter.dart';

import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/view/book_management/components/book/book_comment_bottom_sheet.dart';
import 'package:htlib/src/view/book_management/components/book/book_preview_bottom_sheet.dart';
import 'package:htlib/src/view/book_management/printing/book_printing_screen.dart';
import 'package:htlib/src/view/renting_history_management/components/shortcut/shortcut_book_renting_history_page.dart';
import 'package:htlib/src/view/user_management/components/shortcut/shortcut_book_user_page.dart';
import 'package:htlib/styles.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:htlib/_internal/styled_widget.dart';
import 'package:htlib/src/model/book.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/book_element_tile.dart';

enum BookSheetState { none, preview, comment }

class BookScreen extends StatefulWidget {
  final Book book;
  final bool enableEdited;

  BookScreen(
    this.book, {
    Key? key,
    required this.enableEdited,
  }) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final BookService bookService = Get.find();

  double bookDescHeight(BuildContext context) {
    if (FirebaseAuth.instance.currentUser!.email!.contains('@htlib.com'))
      return (300 - 2) / 4 * 6;
    if (MediaQuery.of(context).size.height < 730) return (300 - 2) / 4 * 2;
    if (MediaQuery.of(context).size.height < 850) return (300 - 2) / 4 * 3;
    return 300;
  }

  Widget bookDesc(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedDefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.primary),
            duration: Durations.fast,
            child: Text(
              "${widget.book.name}",
              textAlign: TextAlign.center,
              maxLines: BuildUtils.specifyForMobile(context,
                  defaultValue: 1, mobile: 2),
              // overflow: TextOverflow.ellipsis,
            )
                .constrained(
                  maxWidth: BuildUtils.specifyForMobile(
                    context,
                    defaultValue: PageBreak.defaultPB.tablet,
                    mobile: MediaQuery.of(context).size.width,
                  )!,
                )
                .padding(horizontal: Insets.sm),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).tileColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.1),
                  blurRadius: 30,
                ),
              ],
              border:
                  Border.all(color: Theme.of(context).dividerColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(
                vertical: Insets.l, horizontal: Insets.mid),
            height: bookDescHeight(context),
            width: BuildUtils.specifyForMobile(
              context,
              defaultValue: PageBreak.defaultPB.tablet,
              mobile: MediaQuery.of(context).size.width,
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                BookElementTile(
                  title: "Mã ISBN",
                  content: "${widget.book.isbn}",
                  enableEditted: widget.enableEdited,
                  onEdit: (value) =>
                      bookService.edit(widget.book.copyWith(isbn: value)),
                ),
                BookElementTile(
                  title: "Giá tiền",
                  content: "${StringUtils.moneyFormat(widget.book.price)}",
                  enableEditted: widget.enableEdited,
                  customContent: (controller, focusNode) {
                    return EditableText(
                      controller: controller!,
                      focusNode: focusNode,
                      selectionColor:
                          Theme.of(context).primaryColor.withOpacity(0.4),
                      cursorColor: Colors.grey,
                      backgroundCursorColor: Colors.transparent,
                      onChanged: (price) {
                        print(price);
                        price = price.replaceAll(",", "");
                        bookService.edit(
                            widget.book.copyWith(price: int.parse(price)));
                      },
                      inputFormatters: [
                        ThousandsFormatter(),
                        MoneyFormatter(),
                      ],
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                      textAlign: TextAlign.center,
                      strutStyle: StrutStyle.fromTextStyle(
                          Theme.of(context).textTheme.subtitle1!),
                    );
                  },
                ),
                BookElementTile(
                  title: "Số lượng",
                  content: "${widget.book.quantity}",
                  enableEditted: widget.enableEdited,
                  onEdit: (value) => bookService
                      .edit(widget.book.copyWith(quantity: int.parse(value))),
                ),
                BookElementTile(
                  title: "Nhà xuất bản",
                  content: "${widget.book.publisher}",
                  enableEditted: widget.enableEdited,
                  onEdit: (value) =>
                      bookService.edit(widget.book.copyWith(publisher: value)),
                ),
                BookElementTile(
                  title: "Năm xuất bản",
                  content: "${widget.book.year}",
                  enableEditted: widget.enableEdited,
                  onEdit: (value) => bookService
                      .edit(widget.book.copyWith(year: int.parse(value))),
                ),
                BookElementTile(
                  title: "Thể loại",
                  content:
                      "${widget.book.type!.length == 1 ? widget.book.type!.first : widget.book.typeToSafeString()}",
                  showDivider: false,
                  enableEditted: widget.enableEdited,
                ),
              ],
            ),
          ),
          if (FirebaseAuth.instance.currentUser!.email!.contains('@htlib.com'))
            ElevatedButton.icon(
              onPressed: () => launch(
                  'https://www.google.com.vn/search?q=${(widget.book.name + ' nội dung sách').replaceAll(' ', '+')}'),
              icon: Icon(Icons.book_rounded),
              label: Text('Mô tả sách'),
            ),
        ],
      );

  AdminService? adminService;
  bool _isLibrarian() =>
      adminService != null &&
      adminService!.currentUser.value.adminType == AdminType.librarian;
  bool isOpenBottomSheet = false;

  BookSheetState _bookSheetState = BookSheetState.none;

  @override
  void initState() {
    super.initState();
    try {
      adminService = Get.find<AdminService>();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: widget.enableEdited == false
            ? []
            : _isLibrarian()
                ? [
                    IconButton(
                      icon: Icon(Icons.picture_as_pdf),
                      color: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () async {
                        if (_bookSheetState != BookSheetState.preview) {
                          if (isOpenBottomSheet) Navigator.pop(context);
                          Future(() {
                            isOpenBottomSheet = true;
                            _bookSheetState = BookSheetState.preview;
                          });
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BookPreviewBottomSheet(book: widget.book),
                            ),
                          );
                          isOpenBottomSheet = false;
                          _bookSheetState = BookSheetState.none;
                        }
                      },
                    ),
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: Icon(Icons.comment),
                          color: Theme.of(context).colorScheme.onPrimary,
                          onPressed: () async {
                            if (_bookSheetState != BookSheetState.comment) {
                              if (isOpenBottomSheet) Navigator.pop(context);
                              Future(() {
                                isOpenBottomSheet = true;
                                _bookSheetState = BookSheetState.comment;
                              });
                              final sheet = showBottomSheet(
                                context: context,
                                builder: (_) =>
                                    BookCommentBottomSheet(book: widget.book),
                              );
                              await sheet.closed;
                              isOpenBottomSheet = false;
                              _bookSheetState = BookSheetState.none;
                            }
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.print),
                      color: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookPrintingScreen(widget.book),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () {
                        Get.find<BookService>().remove(widget.book);
                        Navigator.pop(context);
                      },
                    ),
                  ]
                : [
                    IconButton(
                      icon: Icon(Icons.picture_as_pdf),
                      color: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () async {
                        if (_bookSheetState != BookSheetState.preview) {
                          if (isOpenBottomSheet) Navigator.pop(context);
                          Future(() {
                            isOpenBottomSheet = true;
                            _bookSheetState = BookSheetState.preview;
                          });
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BookPreviewBottomSheet(book: widget.book),
                            ),
                          );
                          isOpenBottomSheet = false;
                          _bookSheetState = BookSheetState.none;
                        }
                      },
                    ),
                  ],
      ),
      floatingActionButton: widget.enableEdited == false
          ? null
          : adminService != null
              ? null
              : HookBuilder(
                  builder: (context) {
                    final isOpenSheet = useRef<bool>();

                    return FloatingActionButton(
                      onPressed: () {
                        if (isOpenSheet.value == true) {
                          isOpenSheet.value = false;
                          Navigator.pop(context);
                        } else {
                          isOpenSheet.value = true;
                          showBottomSheet(
                            context: context,
                            builder: (_) => WillPopScope(
                              onWillPop: () async {
                                isOpenSheet.value = false;
                                return true;
                              },
                              child: BookCommentBottomSheet(book: widget.book),
                            ),
                          );
                        }
                      },
                      child: Icon(Icons.comment),
                    );
                  },
                ),
      body: FirebaseAuth.instance.currentUser!.email!.contains('@htlib.com')
          ? Center(
              child: bookDesc(context).padding(
                vertical: BuildUtils.getResponsive(
                  context,
                  desktop: Insets.xl,
                  tablet: Insets.l,
                  mobile: Insets.m,
                  tabletPortrait: Insets.mid,
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                bookDesc(context).padding(
                  vertical: BuildUtils.getResponsive(
                    context,
                    desktop: Insets.xl,
                    tablet: Insets.l,
                    mobile: Insets.m,
                    tabletPortrait: Insets.mid,
                  ),
                ),
                Container(
                  height: 1.5,
                  color: Theme.of(context).dividerColor,
                  constraints:
                      BoxConstraints(maxWidth: PageBreak.defaultPB.tablet),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    // accentColor: Colors.transparent,
                    focusColor: Colors.black12,
                    highlightColor: Colors.grey.withOpacity(0.1),
                    tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
                          unselectedLabelColor: Colors.grey,
                          indicator: UnderlineTabIndicator(
                            insets: EdgeInsets.zero,
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Theme.of(context).primaryColor),
                          ),
                          labelColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyles.Body1,
                          unselectedLabelStyle: TextStyles.Body1,
                        ),
                  ),
                  child: DefaultTabController(
                    initialIndex: 0,
                    length: 2,
                    child: Column(
                      children: [
                        Builder(
                          builder: (context) {
                            return TabBar(
                              tabs: [
                                Tab(
                                  icon: Icon(Feather.users),
                                  text: "Người đang mượn sách",
                                  iconMargin:
                                      EdgeInsets.only(bottom: Insets.sm),
                                ),
                                Tab(
                                  icon: Icon(Feather.file_text),
                                  text: "Lịch sử cho mượn",
                                  iconMargin:
                                      EdgeInsets.only(bottom: Insets.sm),
                                ),
                              ],
                              onTap: (value) {},
                            );
                          },
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              ShortcutBookUserPage(widget.book),
                              ShortcutBookRentingHistoryPage(widget.book),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ).constrained(maxWidth: PageBreak.defaultPB.tablet).expanded(),
              ],
            ).center(),
    );
  }
}
