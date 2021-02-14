import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/resources/resources.dart';
import 'package:htlib/src/model/book_base.dart';
import 'package:htlib/src/services/book/book_service.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/widget/book_base_list_tile.dart';
import 'package:htlib/styles.dart';

import 'package:styled_widget/styled_widget.dart';
import 'package:htlib/src/view/home/component/home_bottom_bar.dart';
part 'book_management_binding.dart';

class BookManagementScreen extends StatefulWidget {
  static String route = "/book_management";

  @override
  _BookManagementScreenState createState() => _BookManagementScreenState();
}

class _BookManagementScreenState extends State<BookManagementScreen> {
  final GetIt getIt = GetIt.instance;
  int index = 0;
  BookService bookService;
  bool isInit = false;
  List<Widget> actions;

  @override
  void initState() {
    super.initState();
    actions = [
      IconButton(
        icon: Icon(Icons.explicit),
        onPressed: () async {
          List<BookBase> addList =
              await bookService.excelService.getBookBaseList();
          if (addList != null) bookService.mergeList(addList);
        },
        tooltip: "Thêm sách từ file excel",
      ),
      IconButton(
        icon: Icon(Icons.add_chart),
        onPressed: () async {
          List<BookBase> addList =
              await bookService.excelService.getBookBaseList();
          if (addList != null) bookService.mergeList(addList);
        },
        tooltip: "Thêm sách",
      ),
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          showSearch(
            context: context,
            delegate: BookSearchDelegate(bookService),
          );
        },
        tooltip: "Tìm kiếm sách",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (isInit == false) {
      if (getIt.isReadySync<BookService>()) {
        bookService = getIt<BookService>();
        isInit = true;
      } else {
        Future.microtask(() => setState(() {}));
      }
    }
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 3,
          forceElevated: false,
          flexibleSpace: FlexibleSpaceBar(
            background: AnimatedContainer(
              duration: Durations.fast,
              curve: Curves.decelerate,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorDark,
                  ],
                ),
              ),
            ),
            stretchModes: [StretchMode.fadeTitle, StretchMode.zoomBackground],
            title: !PageBreak.defaultPB.isDesktop(context)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        Images.htLogo,
                      ).constrained(maxHeight: 48),
                      Text(AppConfig.title).padding(right: Insets.m),
                    ],
                  )
                : null,
            titlePadding: EdgeInsets.only(top: 12, bottom: 72, left: Insets.m),
          ),
          actions: (!PageBreak.defaultPB.isDesktop(context)) ? null : actions,
          bottom: PageBreak.defaultPB.isDesktop(context)
              ? null
              : HomeBottomBar(actions: actions),
          collapsedHeight: 59.0,
          expandedHeight: PageBreak.defaultPB.isDesktop(context) ? 59.0 : 250.0,
          centerTitle: true,
          pinned: true,
          floating: true,
        ),
        bookService == null
            ? SliverToBoxAdapter(
                child: CircularProgressIndicator()
                    .constrained(height: 150, width: 150)
                    .center()
                    .constrained(
                        height: MediaQuery.of(context).size.height - 60.0),
              )
            : StreamBuilder<List<BookBase>>(
                stream: bookService.listSubcribe.stream,
                initialData: bookService.list,
                builder: (context, snapshot) {
                  List<BookBase> list = snapshot.data ?? [];

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => BookBaseListTile(
                        list[index],
                        onTap: () {
                          bookService.remove(list[index]);
                        },
                      ),
                      childCount: list.length,
                    ),
                  );
                }),
      ],
    );
  }
}
