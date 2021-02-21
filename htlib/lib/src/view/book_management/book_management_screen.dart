import 'dart:async';

import 'package:animations/animations.dart';
import 'package:diffutil_sliverlist/diffutil_sliverlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:htlib/_internal/components/sliver_indicator.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/resources/resources.dart';
import 'package:htlib/src/model/book_base.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/view/home/home_screen.dart';
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
  SortingState _sortingState = SortingState.noSort;
  SortingMode _sortingMode = SortingMode.lth;

  bool isInit = false;
  List<Widget> _actions;

  GlobalKey<SliverAnimatedListState> listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  void initState() {
    super.initState();
    _actions = [
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
  Widget build(BuildContext context) {
    if (isInit == false) {
      if (getIt.isReadySync<BookService>()) {
        bookService = getIt<BookService>();
        isInit = true;
      } else {
        Future.microtask(() => setState(() {}));
      }
    }

    return TweenAnimationBuilder<double>(
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
                                ][_sortingState.index],
                              ),
                              onPressed: () {
                                SortingState newState = SortingState.values[
                                    (_sortingState.index + 1) %
                                        SortingState.values.length];
                                setState(() => _sortingState = newState);
                              },
                            ),
                            HSpace(20.0),
                            if (_sortingState != SortingState.noSort)
                              Tooltip(
                                message: _sortingMode == SortingMode.htl
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
                                        (_sortingMode.index + 1) %
                                            SortingMode.values.length];
                                    setState(() => _sortingMode = newMode);
                                  },
                                  child: Icon(
                                    _sortingMode.index == 0
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
            actions:
                (!PageBreak.defaultPB.isDesktop(context)) ? null : _actions,
            bottom: PageBreak.defaultPB.isDesktop(context)
                ? null
                : HomeBottomBar(
                    actions: _actions,
                    sortingState: _sortingState,
                    sortingMode: _sortingMode,
                    onSort: (state) => setState(() => _sortingState = state),
                    onChangedMode: (mode) =>
                        setState(() => _sortingMode = mode),
                  ),
            collapsedHeight: 59.0,
            expandedHeight:
                PageBreak.defaultPB.isDesktop(context) ? 59.0 : 250.0,
            centerTitle: true,
            pinned: true,
            floating: true,
          ),
          bookService == null
              ? SliverIndicator()
              : BlocBuilder<ListBloc<Book>, ListState<Book>>(
                  cubit: bookService.bookListBloc,
                  builder: (context, state) {
                    return state.maybeWhen<Widget>(
                      initial: () => SliverIndicator(),
                      waiting: () => SliverIndicator(),
                      done: (_list) {
                        if (_sortingState != SortingState.noSort) {
                          _list.sort((b1, b2) {
                            if (_sortingMode == SortingMode.htl) {
                              Book swap = b1;
                              b1 = b2;
                              b2 = swap;
                            }
                            return _sortingState == SortingState.alphabet
                                ? b1.name.compareTo(b2.name)
                                : b1.quantity.compareTo(b2.quantity);
                          });
                        }

                        return DiffUtilSliverList<Book>(
                          builder: (_, book) => OpenContainer(
                            key: ValueKey(book.isbn),
                            openBuilder: (_, __) => BookScreen(book),
                            closedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            closedBuilder: (_, onTap) => BookListTile(
                              book,
                              onTap: onTap,
                            ),
                            transitionType: ContainerTransitionType.fade,
                          ),
                          items: _list,
                          insertAnimationBuilder: (context, animation, child) =>
                              FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                          removeAnimationBuilder: (context, animation, child) =>
                              FadeTransition(
                            opacity: animation,
                            child: SizeTransition(
                              sizeFactor: animation,
                              axisAlignment: 0,
                              child: child,
                            ),
                          ),
                        );
                      },
                      orElse: () => SliverIndicator(),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
