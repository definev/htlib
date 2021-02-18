import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/resources/resources.dart';
import 'package:htlib/src/model/book_base.dart';
import 'package:htlib/src/services/book/book_service.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/widget/book_base_list_tile.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/src/view/book_base/book_base_screen.dart';

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
  BookSortingState bookSortingState = BookSortingState.noSort;
  SortingMode sortingMode = SortingMode.lth;

  bool isInit = false;
  List<Widget> actions;
  List<BookBase> bookBaseList = [];
  UniqueKey bookBaseTween = UniqueKey();
  UniqueKey bookManagementTween = UniqueKey();
  StreamSubscription _bookBaseListSubcription;

  @override
  void initState() {
    super.initState();
    actions = [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: BookSearchDelegate(bookService),
            );
          },
          tooltip: "Tìm kiếm sách",
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _bookBaseListSubcription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isInit == false) {
      if (getIt.isReadySync<BookService>()) {
        bookService = getIt<BookService>();
        _bookBaseListSubcription =
            bookService.listSubcribe.stream.listen((newList) {
          setState(() => bookBaseList = newList);
        });
        bookBaseList = bookService.list;
        isInit = true;
      } else {
        Future.microtask(() => setState(() {}));
      }
    }

    return TweenAnimationBuilder<double>(
      key: bookManagementTween,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Durations.fastest,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: child,
      ),
      child: CustomScrollView(
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
              titlePadding:
                  EdgeInsets.only(top: 12, bottom: 72, left: Insets.m),
            ),
            leadingWidth: 124.0,
            leading: (PageBreak.defaultPB.isDesktop(context))
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                [
                                  Icons.menu,
                                  Icons.sort_by_alpha_rounded,
                                  Icons.sort_rounded,
                                ][bookSortingState.index],
                              ),
                              onPressed: () {
                                BookSortingState newState =
                                    BookSortingState.values[
                                        (bookSortingState.index + 1) %
                                            BookSortingState.values.length];
                                setState(() => bookSortingState = newState);
                              },
                            ),
                            HSpace(20.0),
                            if (bookSortingState != BookSortingState.noSort)
                              Tooltip(
                                message: sortingMode == SortingMode.htl
                                    ? "Cao xuống thấp"
                                    : "Thấp lên cao",
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(2.0),
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                  onPressed: () {
                                    SortingMode newMode = SortingMode.values[
                                        (sortingMode.index + 1) %
                                            SortingMode.values.length];
                                    setState(() => sortingMode = newMode);
                                  },
                                  child: Icon(
                                    sortingMode.index == 0
                                        ? Icons.arrow_upward_rounded
                                        : Icons.arrow_downward_rounded,
                                    color: Colors.white,
                                  ).padding(vertical: 4.0),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                : null,
            actions: (!PageBreak.defaultPB.isDesktop(context)) ? null : actions,
            bottom: PageBreak.defaultPB.isDesktop(context)
                ? null
                : HomeBottomBar(
                    actions: actions,
                    bookSortingState: bookSortingState,
                    sortingMode: sortingMode,
                    onSort: (state) => setState(() => bookSortingState = state),
                    onChangedMode: (mode) => setState(() => sortingMode = mode),
                  ),
            collapsedHeight: 59.0,
            expandedHeight:
                PageBreak.defaultPB.isDesktop(context) ? 59.0 : 250.0,
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
              : Builder(
                  builder: (context) {
                    List<BookBase> list = List.generate(
                      bookBaseList.length,
                      (index) => bookBaseList[index],
                    );

                    if (bookSortingState != BookSortingState.noSort) {
                      list.sort((b1, b2) {
                        if (sortingMode == SortingMode.htl) {
                          BookBase swap = b1;
                          b1 = b2;
                          b2 = swap;
                        }
                        return bookSortingState == BookSortingState.alphabet
                            ? b1.name.compareTo(b2.name)
                            : b1.quantity.compareTo(b2.quantity);
                      });
                    }

                    return SliverAnimatedList(
                      itemBuilder: (context, index, animation) =>
                          FadeTransition(
                        opacity: animation,
                        child: OpenContainer(
                          openBuilder: (_, __) => BookBaseScreen(
                            index: index,
                            bookBase: list[index],
                          ),
                          closedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          closedBuilder: (_, __) =>
                              BookBaseListTile(list[index]),
                          transitionType: ContainerTransitionType.fade,
                        ),
                      ),
                      initialItemCount: list.length,
                    );
                  },
                ),
        ],
      ),
    );
  }
}
