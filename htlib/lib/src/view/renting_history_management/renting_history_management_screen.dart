import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';

import 'package:htlib/_internal/components/sliver_indicator.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/utils/painter/logo.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_card.dart';
import 'package:htlib/src/view/book_management/components/book_bottom_bar.dart';
import 'package:htlib/src/view/home/home_screen.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_screen.dart';
import 'package:htlib/src/widget/htlib_sliver_app_bar.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

part 'renting_history_management_binding.dart';

class RentingHistoryManagementScreen extends StatefulWidget {
  static String route = "/user_management";

  @override
  _RentingHistoryManagementScreenState createState() =>
      _RentingHistoryManagementScreenState();
}

class _RentingHistoryManagementScreenState
    extends State<RentingHistoryManagementScreen> {
  int index = 0;
  SortingState _sortingState = SortingState.noSort;
  SortingMode _sortingMode = SortingMode.lth;

  bool isInit = false;
  List<Widget> _actions;

  List<Icon> _icon = [
    Icon(FontAwesome.calendar_o),
    Icon(FontAwesome.calendar_times_o),
    Icon(FontAwesome.calendar_minus_o),
  ];

  ListBloc<RentingHistory> _bloc =
      Get.find<RentingHistoryService>().rentingHistoryListBloc;
  GlobalKey<SliverAnimatedListState> listKey =
      GlobalKey<SliverAnimatedListState>();

  List<RentingHistory> _mockList = List.generate(
    20,
    (_) => RentingHistory.random(),
  );

  Map<RentingHistoryStateCode, List<RentingHistory>> _sortedBrListMap = {};

  void _setSortedList(List<RentingHistory> list) {
    DateTime now = DateTime.now();

    if (list.isEmpty) {
      _sortedBrListMap = {
        RentingHistoryStateCode.renting: [],
        RentingHistoryStateCode.warning: [],
        RentingHistoryStateCode.expired: []
      };
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
    _sortedBrListMap.addEntries([
      MapEntry(RentingHistoryStateCode.renting, list.sublist(0, okLastIndex))
    ]);
    list.removeRange(0, okLastIndex);

    int warningLastIndex = list.indexWhere((br) {
      if (br.endAt.isBefore(now)) return true;
      return false;
    });
    _sortedBrListMap.addEntries([
      MapEntry(
          RentingHistoryStateCode.warning, list.sublist(0, warningLastIndex))
    ]);
    list.removeRange(0, warningLastIndex);

    _sortedBrListMap
        .addEntries([MapEntry(RentingHistoryStateCode.expired, list)]);
  }

  @override
  void initState() {
    super.initState();
    _actions = [];

    _setSortedList(_mockList);
  }

  Widget _brListGridView(List<RentingHistory> list) {
    DateTime now = DateTime.now();
    return SliverPadding(
      padding: EdgeInsets.all(Insets.m - Insets.sm),
      sliver: SliverGrid.extent(
        maxCrossAxisExtent: 350.0,
        childAspectRatio: 0.9,
        children: List.generate(
          list.length,
          (brListIndex) => OpenContainer(
            closedElevation: 0.0,
            closedColor: Colors.transparent,
            closedBuilder: (context, action) => RentingHistoryCard(
              rentingHistory: list[brListIndex],
              onTap: action,
              now: now,
            ),
            openBuilder: (context, action) => RentingHistoryScreen(
              rentingHistory: list[brListIndex],
              onTap: action,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDone(List<RentingHistory> list) {
    if (_sortedBrListMap[RentingHistoryStateCode.renting].isEmpty &&
        _sortedBrListMap[RentingHistoryStateCode.warning].isEmpty &&
        _sortedBrListMap[RentingHistoryStateCode.expired].isEmpty) {
      return [
        SliverFillRemaining(
          child: LogoIndicator(
            size: 200.0,
          ).center(),
          // child: Text(
          //   "Chưa có đơn mượn nào cần xử lí.",
          //   style: Theme.of(context).textTheme.headline6,
          // ).center(),
        ),
      ];
    }
    return [
      if (_sortedBrListMap[RentingHistoryStateCode.renting].isNotEmpty)
        _stickyHeader(0),
      if (_sortedBrListMap[RentingHistoryStateCode.warning].isNotEmpty)
        _stickyHeader(1),
      if (_sortedBrListMap[RentingHistoryStateCode.expired].isNotEmpty)
        _stickyHeader(2),
    ];
  }

  SliverStickyHeader _stickyHeader(int stateCodeIndex) {
    return SliverStickyHeader(
      header: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          toolbarHeight: 60 - Insets.xs + Insets.m,
          flexibleSpace: SizedBox(height: 60 - Insets.xs + Insets.m),
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          leading: _icon[stateCodeIndex],
          title: Text(
            "${AppConfig.rentingHistoryCode[RentingHistoryStateCode.values[stateCodeIndex]]}",
          ),
        ),
      ),
      sliver: _brListGridView(
          _sortedBrListMap[RentingHistoryStateCode.values[stateCodeIndex]]),
    );
  }

  Widget _appBar() {
    return HtlibSliverAppBar(
      bottom: BookBottomBar(
        actions: _actions,
        sortingState: _sortingState,
        sortingMode: _sortingMode,
        onSort: (state) => setState(() => _sortingState = state),
        onChangedMode: (mode) => setState(() => _sortingMode = mode),
      ),
      title: AppConfig.tabRentingHistory,
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
      child: BlocBuilder<ListBloc<RentingHistory>, ListState<RentingHistory>>(
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
