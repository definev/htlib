import "package:flutter/material.dart";
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:htlib/_internal/components/adaptive_scaffold.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/resources/resources.dart';
import 'package:htlib/src/model/book_base.dart';
import 'package:htlib/src/services/book/book_service.dart';
import 'package:htlib/src/view/home/component/home_bottom_bar.dart';
import 'package:htlib/src/widget/book_base_list_tile.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

part 'home_binding.dart';

class HomeScreen extends StatefulWidget {
  static String route = "/";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetIt getIt = GetIt.instance;
  int index = 0;
  BookService bookService;

  @override
  Widget build(BuildContext context) {
    bookService = getIt<BookService>();

    return AdaptiveScaffold(
      currentIndex: index,
      destinations: [
        AdaptiveScaffoldDestination(
            title: "Quản lí sách", icon: Feather.book_open),
        AdaptiveScaffoldDestination(
            title: "Quản lí người dùng", icon: Feather.user),
        AdaptiveScaffoldDestination(
            title: "Lịch sử mượn", icon: Feather.file_text),
      ],
      logo: !PageBreak.defaultPB.isMobile(context)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      padding: EdgeInsets.all(Insets.sm),
                      child: Image.asset(Images.htLogo),
                    ),
                    if (PageBreak.defaultPB.isDesktop(context)) ...[
                      HSpace(Insets.l),
                      Text("HTLIB"),
                    ],
                  ],
                ),
                Divider(),
              ],
            )
          : null,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      onNavigationIndexChange: (value) => setState(() => index = value),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
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
              stretchModes: [
                StretchMode.fadeTitle,
                StretchMode.zoomBackground,
              ],
              title: PageBreak.defaultPB.isMobile(context)
                  ? Image.asset(
                      Images.htLogo,
                    ).constrained(maxHeight: 48)
                  : null,
              titlePadding: EdgeInsets.only(top: 12, bottom: 72, left: 14),
            ),
            title: Text("Quản lí sách"),
            bottom: HomeBottomBar(),
            collapsedHeight: 60.0,
            centerTitle: true,
            pinned: true,
            floating: true,
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  List<BookBase> addList =
                      await bookService.excelService.getBookBaseList();
                  if (addList != null) bookService.mergeList(addList);
                },
              ),
              IconButton(
                  icon: Icon(AntDesign.search1),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: BookSearchDelegate(bookService),
                    );
                  }),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text("ITEM $index"),
                leading: Icon(AntDesign.CodeSandbox),
                subtitle: Text("JUST A TEXT"),
                onTap: () {},
              ),
              childCount: 25,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text("ITEM $index"),
                leading: Icon(AntDesign.CodeSandbox),
                subtitle: Text("JUST A TEXT"),
                onTap: () {},
              ),
              childCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}
