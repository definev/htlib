import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';

import 'package:htlib/_internal/components/sliver_indicator.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/resources/resources.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/borrowing_history.dart';
import 'package:htlib/src/services/borrowing_history_service.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/view/borrowing_history_management/components/borrowing_history_card.dart';
import 'package:htlib/src/view/book_management/components/book_bottom_bar.dart';
import 'package:htlib/src/view/home/home_screen.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

part 'borrowing_history_management_binding.dart';

class BorrowingHistoryManagementScreen extends StatefulWidget {
  static String route = "/user_management";

  @override
  _BorrowingHistoryManagementScreenState createState() =>
      _BorrowingHistoryManagementScreenState();
}

class _BorrowingHistoryManagementScreenState
    extends State<BorrowingHistoryManagementScreen> {
  int index = 0;
  SortingState _sortingState = SortingState.noSort;
  SortingMode _sortingMode = SortingMode.lth;

  bool isInit = false;
  List<Widget> _actions;

  ListBloc<BorrowingHistory> _bloc =
      Get.find<BorrowingHistoryService>().borrowingHistoryListBloc;
  GlobalKey<SliverAnimatedListState> listKey =
      GlobalKey<SliverAnimatedListState>();

  List<BorrowingHistory> _mockList = List.generate(
    0,
    (_) => BorrowingHistory.random(),
  );

  Map<String, List<BorrowingHistory>> _sortedBrListMap = {};

  void _setSortedList(List<BorrowingHistory> list) {
    DateTime now = DateTime.now();

    if (list.isEmpty) {
      _sortedBrListMap = {"ok": [], "warning": [], "expired": []};
      return;
    }

    list.sort((e1, e2) => e2.endAt.compareTo(e1.endAt));
    int okLastIndex = list.indexWhere(
      (br) {
        bool res = true;
        if (!br.endAt.isAfter(now)) return false;
        if (br.endAt.difference(now) >
            Duration(days: Get.find<HtlibDb>().config.warningDay)) return false;

        return res;
      },
    );
    _sortedBrListMap.addEntries([MapEntry("ok", list.sublist(0, okLastIndex))]);
    list.removeRange(0, okLastIndex);

    int warningLastIndex = list.indexWhere((br) {
      if (br.endAt.isBefore(now)) return true;
      return false;
    });
    _sortedBrListMap
        .addEntries([MapEntry("warning", list.sublist(0, warningLastIndex))]);
    list.removeRange(0, warningLastIndex);

    _sortedBrListMap.addEntries([MapEntry("expired", list)]);
  }

  @override
  void initState() {
    super.initState();
    _actions = [];

    _setSortedList(_mockList);
  }

  Widget _brListGridView(List<BorrowingHistory> list) {
    DateTime now = DateTime.now();
    return SliverPadding(
      padding: EdgeInsets.all(Insets.sm),
      sliver: SliverGrid.extent(
        maxCrossAxisExtent: 400.0,
        crossAxisSpacing: Insets.sm,
        mainAxisSpacing: Insets.sm,
        children: List.generate(
          list.length,
          (brListIndex) => OpenContainer(
            closedElevation: 0.0,
            closedColor: Colors.transparent,
            closedBuilder: (context, action) => BorrowingHistoryCard(
              borrowingHistory: list[brListIndex],
              onTap: action,
              now: now,
            ),
            openBuilder: (context, action) =>
                Container(color: Colors.amber).gestures(
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDone(List<BorrowingHistory> list) {
    if (_sortedBrListMap["ok"].isEmpty &&
        _sortedBrListMap["warning"].isEmpty &&
        _sortedBrListMap["expired"].isEmpty) {
      return [
        SliverFillRemaining(
          child: Text(
            "Chưa có đơn mượn nào cần xử lí.",
            style: Theme.of(context).textTheme.headline6,
          ).center(),
        ),
      ];
    }
    return [
      if (_sortedBrListMap["ok"].isNotEmpty)
        SliverStickyHeader(
          header: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: Text("Đang trong thời gian mượn đọc"),
          ),
          sliver: _brListGridView(_sortedBrListMap["ok"]),
        ),
      if (_sortedBrListMap["warning"].isNotEmpty)
        SliverStickyHeader(
          header: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: Text(
                "Sắp đến hạn phải trả (<= ${Get.find<HtlibDb>().config.warningDay} ngày nữa)"),
          ),
          sliver: _brListGridView(_sortedBrListMap["warning"]),
        ),
      if (_sortedBrListMap["expired"].isNotEmpty)
        SliverStickyHeader(
          header: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: Text("Đã quá hạn"),
          ),
          sliver: _brListGridView(_sortedBrListMap["expired"]),
        ),
    ];

    // children: list
    //     .map(
    //       (br) => OpenContainer(
    //         closedBuilder: (context, action) => BorrowingHistoryCard(),
    //         openBuilder: (context, action) => Container(color: Colors.amber),
    //       ),
    //     )
    //     .toList(),
  }

  Widget _appBar() {
    return SliverAppBar(
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
      leadingWidth: 124.0,
      actions: (!PageBreak.defaultPB.isDesktop(context)) ? null : _actions,
      bottom: PageBreak.defaultPB.isDesktop(context)
          ? null
          : BookBottomBar(
              actions: _actions,
              sortingState: _sortingState,
              sortingMode: _sortingMode,
              onSort: (state) => setState(() => _sortingState = state),
              onChangedMode: (mode) => setState(() => _sortingMode = mode),
            ),
      collapsedHeight: 59.0,
      expandedHeight: PageBreak.defaultPB.isDesktop(context) ? 59.0 : 250.0,
      centerTitle: true,
      pinned: true,
      floating: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isInit == false) {}

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Durations.fastest,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: child,
      ),
      child:
          BlocBuilder<ListBloc<BorrowingHistory>, ListState<BorrowingHistory>>(
        cubit: _bloc,
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              _appBar(),
              ...state.maybeWhen<List<Widget>>(
                initial: () => [SliverIndicator(height: 300.0)],
                waiting: () => [SliverIndicator(height: 300.0)],
                done: (list) => _buildDone(list),
                orElse: () => [SliverIndicator(height: 300.0)],
              ),
            ],
          );
        },
      ),
    );
  }
}
