import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';

import 'package:htlib/_internal/components/sliver_indicator.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/utils/painter/logo.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_bottom_bar.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_grid_tile.dart';
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

  HtlibDb db = Get.find<HtlibDb>();

  bool isInit = false;
  List<Widget> _actions;

  List<Icon> _icon = [
    Icon(FontAwesome.calendar_o),
    Icon(FontAwesome.calendar_minus_o),
    Icon(FontAwesome.calendar_times_o),
  ];

  RentingHistoryService rentingHistoryService =
      Get.find<RentingHistoryService>();
  GlobalKey<SliverAnimatedListState> listKey =
      GlobalKey<SliverAnimatedListState>();

  UserService userService = Get.find();

  Map<RentingHistoryStateCode, List<RentingHistory>> _sortedBrListMap = {};

  var data = List.generate(20, (index) => RentingHistory.random());

  void _setSortedList(List<RentingHistory> list) {
    DateTime now = DateTime.now();

    _sortedBrListMap = {
      RentingHistoryStateCode.renting: [],
      RentingHistoryStateCode.warning: [],
      RentingHistoryStateCode.expired: []
    };

    if (list.isEmpty) return;

    list.forEach((e) {
      if (e.endAt.isBefore(now)) {
        _sortedBrListMap[RentingHistoryStateCode.expired].add(e);
      } else {
        if (e.endAt.difference(now) <= db.config.warningDay.days) {
          _sortedBrListMap[RentingHistoryStateCode.warning].add(e);
        } else {
          _sortedBrListMap[RentingHistoryStateCode.renting].add(e);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _actions = [];
    _setSortedList(data);
  }

  Widget _brListGridView(List<RentingHistory> list) {
    DateTime now = DateTime.now();
    return SliverPadding(
      padding: EdgeInsets.all(Insets.m - Insets.sm),
      sliver: SliverGrid.extent(
        maxCrossAxisExtent: 400.0,
        childAspectRatio: PageBreak.defaultPB.isMobile(context) ? 1.18 : 1.7,
        children: List.generate(
          list.length,
          (brListIndex) => OpenContainer(
            closedElevation: 0.0,
            closedColor: Colors.transparent,
            closedBuilder: (context, action) => RentingHistoryGridTile(
              userService: userService,
              rentingHistory: list[brListIndex],
              onTap: action,
              now: now,
            ),
            openBuilder: (context, action) => RentingHistoryScreen(
              userService: userService,
              rentingHistory: list[brListIndex],
              onTap: action,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDone(List<RentingHistory> list) {
    _setSortedList(list);
    if (_sortedBrListMap[RentingHistoryStateCode.renting].isEmpty &&
        _sortedBrListMap[RentingHistoryStateCode.warning].isEmpty &&
        _sortedBrListMap[RentingHistoryStateCode.expired].isEmpty) {
      return [
        SliverFillRemaining(
          child: LogoBanner(
            content: "Không có đơn cần xử lí",
          ).center(),
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
      header: Container(
        height: 59.0,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black26
                    : Colors.white24,
                blurRadius: 3,
                offset: Offset(0, 3),
              )
            ]),
        child: Row(
          children: [
            HSpace(8.0),
            IconButton(
                icon: _icon[stateCodeIndex],
                color: Theme.of(context).colorScheme.onSecondary,
                onPressed: () {},
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent),
            HSpace(20.0),
            Text(
              "${AppConfig.rentingHistoryCode[RentingHistoryStateCode.values[stateCodeIndex]]}",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
          ],
        ),
      ),
      sliver: _brListGridView(
          _sortedBrListMap[RentingHistoryStateCode.values[stateCodeIndex]]),
    );
  }

  Widget _appBar() {
    return HtlibSliverAppBar(
      bottom: RentingHistoryBottomBar(
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
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Durations.fastest,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: child,
      ),
      child: BlocBuilder<ListBloc<RentingHistory>, ListState<RentingHistory>>(
        cubit: rentingHistoryService.rentingHistoryListBloc,
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
