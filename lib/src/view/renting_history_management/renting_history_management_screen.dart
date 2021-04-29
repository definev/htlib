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
import 'package:htlib/src/services/state_management/list/list_cubit.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/utils/painter/logo.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_bottom_bar.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_grid_tile.dart';
import 'package:htlib/src/view/renting_history_management/components/dialog/scanner_screen.dart';
import 'package:htlib/src/widget/htlib_sliver_app_bar.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/_internal/styled_widget.dart';

part 'renting_history_management_binding.dart';

class RentingHistoryManagementScreen extends StatefulWidget {
  static String route = "/user_management";

  @override
  _RentingHistoryManagementScreenState createState() =>
      _RentingHistoryManagementScreenState();
}

class _RentingHistoryManagementScreenState
    extends State<RentingHistoryManagementScreen> {
  final HtlibDb db = Get.find<HtlibDb>();

  final List<Icon> _icon = [
    Icon(FontAwesome.calendar_o),
    Icon(FontAwesome.calendar_minus_o),
    Icon(FontAwesome.calendar_times_o),
  ];

  final RentingHistoryService rentingHistoryService =
      Get.find<RentingHistoryService>();

  final GlobalKey<SliverAnimatedListState> listKey =
      GlobalKey<SliverAnimatedListState>();

  final UserService userService = Get.find();

  Map<RentingHistoryStateCode, List<RentingHistory>> _sortList(
    List<RentingHistory> list,
  ) {
    DateTime now = DateTime.now();

    var _sortedBrListMap = {
      RentingHistoryStateCode.renting: <RentingHistory>[],
      RentingHistoryStateCode.warning: <RentingHistory>[],
      RentingHistoryStateCode.expired: <RentingHistory>[],
      RentingHistoryStateCode.returned: <RentingHistory>[],
    };

    if (list.isEmpty) return _sortedBrListMap;
    list.forEach((e) => _sortedBrListMap[getStateCode(e, now, db)]!.add(e));
    return _sortedBrListMap;
  }

  Widget _brListGridView(BuildContext context, List<RentingHistory> list,
      RentingHistoryStateCode stateCode) {
    DateTime now = DateTime.now();
    return SliverPadding(
      padding: EdgeInsets.all(Insets.m - Insets.sm),
      sliver: SliverGrid.extent(
        maxCrossAxisExtent: 400.0,
        childAspectRatio: PageBreak.defaultPB.isMobile(context) ? 1.4 : 1.4,
        children: List.generate(
          list.length,
          (brListIndex) => RentingHistoryGridTile(
            userService: userService,
            rentingHistory: list[brListIndex],
            onTap: () {},
            now: now,
            stateCode: stateCode,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDone(BuildContext context,
      Map<RentingHistoryStateCode, List<RentingHistory>> _sortedBrListMap) {
    if (_sortedBrListMap[RentingHistoryStateCode.renting]!.isEmpty &&
        _sortedBrListMap[RentingHistoryStateCode.warning]!.isEmpty &&
        _sortedBrListMap[RentingHistoryStateCode.expired]!.isEmpty) {
      return [
        SliverFillRemaining(
          child: LogoBanner(
            content: "Không có đơn cần xử lí",
          ).center(),
        ),
      ];
    }
    return [
      if (_sortedBrListMap[RentingHistoryStateCode.renting]!.isNotEmpty)
        _stickyHeader(context, _sortedBrListMap, 0),
      if (_sortedBrListMap[RentingHistoryStateCode.warning]!.isNotEmpty)
        _stickyHeader(context, _sortedBrListMap, 1),
      if (_sortedBrListMap[RentingHistoryStateCode.expired]!.isNotEmpty)
        _stickyHeader(context, _sortedBrListMap, 2),
    ];
  }

  SliverStickyHeader _stickyHeader(
    BuildContext context,
    Map<RentingHistoryStateCode, List<RentingHistory>> _sortedBrListMap,
    int stateCodeIndex,
  ) {
    return SliverStickyHeader(
      key: ValueKey("StickyHeader: $stateCodeIndex"),
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
                  .headline6!
                  .copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
          ],
        ),
      ),
      sliver: _brListGridView(
        context,
        _sortedBrListMap[RentingHistoryStateCode.values[stateCodeIndex]]!,
        RentingHistoryStateCode.values[stateCodeIndex],
      ),
    );
  }

  Widget _appBar() {
    return HtlibSliverAppBar(
      bottom: RentingHistoryBottomBar(
        actions: GetPlatform.isAndroid
            ? [
                IconButton(
                  icon: Icon(Icons.scanner_outlined,
                      color: Theme.of(context).colorScheme.onPrimary),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScannerScreen()));
                  },
                ).paddingOnly(right: Insets.sm),
              ]
            : <Widget>[],
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
      child: BlocBuilder<ListCubit<RentingHistory>, ListState<RentingHistory>>(
        bloc: rentingHistoryService.rentingHistoryListCubit,
        builder: (context, state) {
          return state.when<Widget>(
            initial: () => CustomScrollView(
              slivers: [
                _appBar(),
                SliverIndicator(height: 300.0),
              ],
            ),
            waiting: () => CustomScrollView(
              slivers: [
                _appBar(),
                SliverIndicator(height: 300.0),
              ],
            ),
            done: (list) => CustomScrollView(
              slivers: [
                _appBar(),
                ..._buildDone(context, _sortList(list as List<RentingHistory>)),
              ],
            ),
          );
        },
      ),
    );
  }
}
