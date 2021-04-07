import 'package:diffutil_sliverlist/diffutil_sliverlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import 'package:htlib/_internal/components/sliver_indicator.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/state_management/cubit_list/cubit/list_cubit.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/utils/painter/logo.dart';
import 'package:htlib/src/view/book_management/components/classify_book/classify_book_screen.dart';
import 'package:htlib/src/view/home/home_screen.dart';
import 'package:htlib/src/view/book_management/components/book_list_tile.dart';
import 'package:htlib/src/widget/htlib_sliver_app_bar.dart';
import 'package:htlib/styles.dart';

import 'package:htlib/src/view/book_management/components/book_bottom_bar.dart';
part 'book_management_binding.dart';

class BookManagementScreen extends StatefulWidget {
  static String route = "/home/books";

  @override
  _BookManagementScreenState createState() => _BookManagementScreenState();
}

class _BookManagementScreenState extends State<BookManagementScreen> {
  int index = 0;
  BookService? bookService;
  SortingState _sortingState = SortingState.noSort;
  SortingMode _sortingMode = SortingMode.lth;

  bool isInit = false;

  bool isClassify = false;

  GlobalKey<SliverAnimatedListState> listKey =
      GlobalKey<SliverAnimatedListState>();

  Widget _appBar() {
    return HtlibSliverAppBar(
      bottom: BookBottomBar(
        actions: [
          IconButton(
            icon: Icon(Icons.print,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {},
            tooltip: "In hàng loạt",
          ),
          IconButton(
            icon: Icon(
                isClassify ? Icons.analytics_outlined : Icons.analytics_rounded,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              setState(() {
                isClassify = !isClassify;
              });
            },
            tooltip: "Phân loại",
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Feather.search),
              color: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: BookSearchDelegate(bookService),
                );
              },
              tooltip: "Tìm kiếm sách",
            ),
          ),
        ],
        sortingState: _sortingState,
        sortingMode: _sortingMode,
        onSort: (state) => setState(() => _sortingState = state),
        onChangedMode: (mode) => setState(() => _sortingMode = mode),
      ),
      title: AppConfig.tabBook,
      leading: Row(
        children: [
          HSpace(8.0),
          Tooltip(
            message: [
              "Sắp xếp",
              "Sắp xếp theo tên",
              "Sắp xếp theo số lượng",
            ][_sortingState.index],
            child: IconButton(
              icon: Icon(
                [
                  Icons.menu,
                  Icons.sort_by_alpha_rounded,
                  Icons.sort_rounded,
                ][_sortingState.index],
              ),
              onPressed: () {
                setState(() => _sortingState = SortingState.values[
                    (_sortingState.index + 1) % SortingState.values.length]);
              },
            ),
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
                        Theme.of(context).colorScheme.secondary),
                  ),
                  onPressed: () {
                    SortingMode mode = SortingMode.values[
                        (_sortingMode.index + 1) % SortingMode.values.length];
                    setState(() => _sortingMode = mode);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Icon(
                      _sortingMode.index == 0
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  )),
            ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
              isClassify ? Icons.analytics_outlined : Icons.analytics_rounded,
              color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            setState(() {
              isClassify = !isClassify;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(Feather.search),
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookSearchDelegate(bookService),
              );
            },
            tooltip: "Tìm kiếm sách",
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isInit == false) {
      bookService = Get.find<BookService>();
      isInit = true;
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
          _appBar(),
          BlocBuilder<ListCubit<Book>, ListState<Book>>(
            bloc: bookService!.bookListCubit,
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

                  if (_list.isEmpty) {
                    return SliverFillRemaining(
                      child:
                          Center(child: LogoBanner(content: "Không có sách")),
                    );
                  }

                  if (isClassify) return ClassifyBookScreen();

                  return DiffUtilSliverList<Book>(
                    builder: (_, book) =>
                        BookListTile(book, enableEdited: true),
                    items: _list as List<Book>,
                    insertAnimationBuilder: (context, animation, child) =>
                        FadeTransition(opacity: animation, child: child),
                    removeAnimationBuilder: (context, animation, child) =>
                        FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: 0,
                          child: child),
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
