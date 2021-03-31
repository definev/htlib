import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/input_formatter.dart';

import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/view/book_management/printing/book_printing_screen.dart';
import 'package:htlib/src/view/renting_history_management/components/shortcut/shortcut_book_renting_history_page.dart';
import 'package:htlib/src/view/user_management/components/shortcut/shortcut_book_user_page.dart';
import 'package:htlib/styles.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:htlib/_internal/styled_widget.dart';
import 'package:htlib/src/model/book.dart';

import 'widgets/book_element_tile.dart';

class BookScreen extends StatelessWidget {
  final Book book;
  final Function()? onRemove;
  final bool enableEdited;
  final BookService bookService = Get.find();

  BookScreen(
    this.book, {
    Key? key,
    this.onRemove,
    required this.enableEdited,
  }) : super(key: key);

  double bookDescHeight(BuildContext context) {
    if (MediaQuery.of(context).size.height < 730) return (300 - 2) / 4 * 2;
    if (MediaQuery.of(context).size.height < 850) return (300 - 2) / 4 * 3;
    return 300;
  }

  Widget bookDesc(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedDefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Theme.of(context).colorScheme.primary),
            duration: Durations.fast,
            child: SelectableText(
              "${book.name}",
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
            child: Scrollbar(
              thickness: 8,
              radius: Radius.circular(10),
              showTrackOnHover: true,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  BookElementTile(
                    title: "Mã ISBN",
                    content: "${book.isbn}",
                    enableEditted: enableEdited,
                    onEdit: (value) =>
                        bookService.edit(book.copyWith(isbn: value)),
                  ),
                  BookElementTile(
                    title: "Giá tiền",
                    content: "${StringUtils.moneyFormat(book.price)}",
                    enableEditted: enableEdited,
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
                          bookService
                              .edit(book.copyWith(price: int.parse(price)));
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
                    content: "${book.quantity}",
                    enableEditted: enableEdited,
                    onEdit: (value) => bookService
                        .edit(book.copyWith(quantity: int.parse(value))),
                  ),
                  BookElementTile(
                    title: "Nhà xuất bản",
                    content: "${book.publisher}",
                    enableEditted: enableEdited,
                    onEdit: (value) =>
                        bookService.edit(book.copyWith(publisher: value)),
                  ),
                  BookElementTile(
                    title: "Năm xuất bản",
                    content: "${book.year}",
                    enableEditted: enableEdited,
                    onEdit: (value) =>
                        bookService.edit(book.copyWith(year: int.parse(value))),
                  ),
                  BookElementTile(
                    title: "Thể loại",
                    content:
                        "${book.type!.length == 1 ? book.type!.first : book.typeToSafeString()}",
                    showDivider: false,
                    enableEditted: enableEdited,
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: enableEdited
            ? [
                IconButton(
                  icon: Icon(Icons.print),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookPrintingScreen(book),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Get.find<BookService>().remove(book);
                    Navigator.pop(context);
                  },
                ),
              ]
            : [],
      ),
      body: Column(
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
            constraints: BoxConstraints(maxWidth: PageBreak.defaultPB.tablet!),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              accentColor: Colors.transparent,
              focusColor: Colors.black12,
              highlightColor: Colors.grey.withOpacity(0.1),
              tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
                    unselectedLabelColor: Colors.grey,
                    indicator: UnderlineTabIndicator(
                      insets: EdgeInsets.zero,
                      borderSide: BorderSide(
                          width: 2.0, color: Theme.of(context).primaryColor),
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
                            iconMargin: EdgeInsets.only(bottom: Insets.sm),
                          ),
                          Tab(
                            icon: Icon(Feather.file_text),
                            text: "Lịch sử cho mượn",
                            iconMargin: EdgeInsets.only(bottom: Insets.sm),
                          ),
                        ],
                        onTap: (value) {},
                      );
                    },
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ShortcutBookUserPage(book),
                        ShortcutBookRentingHistoryPage(book),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ).constrained(maxWidth: PageBreak.defaultPB.tablet!).expanded(),
        ],
      ).center(),
    );
  }
}
