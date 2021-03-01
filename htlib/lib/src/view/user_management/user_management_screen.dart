import 'dart:convert';
import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:diffutil_sliverlist/diffutil_sliverlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/sliver_indicator.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/state_management/core/list/list_bloc.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/view/user_management/components/user_bottom_bar.dart';
import 'package:htlib/src/view/home/home_screen.dart';
import 'package:htlib/src/view/user_management/components/user_grid_tile.dart';
import 'package:htlib/src/view/user_management/components/user_list_tile.dart';
import 'package:htlib/src/view/user_management/components/user_screen.dart';
import 'package:htlib/src/widget/htlib_sliver_app_bar.dart';
import 'package:htlib/styles.dart';

part 'user_management_binding.dart';

class UserManagementScreen extends StatefulWidget {
  static String route = "/user_management";

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  int index = 0;
  UserService userService;
  SortingState _sortingState = SortingState.noSort;
  SortingMode _sortingMode = SortingMode.lth;

  /// [List = 0] [Grid = 1]
  int mode = 0;

  bool isInit = false;

  GlobalKey<SliverAnimatedListState> listKey =
      GlobalKey<SliverAnimatedListState>();

  List<Uint8List> _imageList = [];

  @override
  void initState() {
    super.initState();
  }

  Widget _appBar() {
    return HtlibSliverAppBar(
      bottom: UserBottomBar(
        actions: [
          IconButton(
            icon: Icon(
              mode == 0 ? Feather.grid : Feather.list,
              key: ValueKey("Viewmode: $mode"),
            ),
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              setState(() => mode == 0 ? mode = 1 : mode = 0);
            },
            tooltip: "Tìm kiếm sách",
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Feather.search),
              color: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {},
              tooltip: "Tìm kiếm sách",
            ),
          ),
        ],
        sortingState: _sortingState,
        sortingMode: _sortingMode,
        onSort: (state) => setState(() => _sortingState = state),
        onChangedMode: (mode) => setState(() => _sortingMode = mode),
      ),
      title: AppConfig.tabUser,
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
            mode == 0 ? Feather.grid : Feather.list,
            key: ValueKey("Viewmode: $mode"),
          ),
          onPressed: () {
            setState(() => mode == 0 ? mode = 1 : mode = 0);
          },
          tooltip: "Tìm kiếm sách",
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(Feather.search),
            onPressed: () {},
            tooltip: "Tìm kiếm sách",
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isInit == false) {
      userService = Get.find<UserService>();
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
          userService == null
              ? SliverIndicator()
              : BlocBuilder<ListBloc<User>, ListState<User>>(
                  cubit: userService.userListBloc,
                  builder: (context, state) {
                    return state.maybeWhen<Widget>(
                      initial: () => SliverIndicator(),
                      waiting: () => SliverIndicator(),
                      done: (_list) {
                        if (_list.length != _imageList.length) {
                          _imageList = _list
                              .map((user) => base64Decode(user.image))
                              .toList();
                        }
                        if (_sortingState != SortingState.noSort) {
                          _list.sort((b1, b2) {
                            if (_sortingMode == SortingMode.htl) {
                              User swap = b1;
                              b1 = b2;
                              b2 = swap;
                            }
                            return _sortingState == SortingState.alphabet
                                ? b1.name.compareTo(b2.name)
                                : b1.quantity.compareTo(b2.quantity);
                          });
                        }

                        if (mode == 1) {
                          List<Widget> children = [];
                          for (int i = 0; i < _list.length; i++) {
                            children.add(
                              UserGridTile(
                                _list[i],
                                image: _imageList[i],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => UserScreen(_list[i]),
                                    ),
                                  );
                                },
                              ),
                            );
                          }

                          return SliverPadding(
                            padding: EdgeInsets.all(Insets.m),
                            sliver: SliverGrid.extent(
                              maxCrossAxisExtent:
                                  PageBreak.defaultPB.isMobile(context)
                                      ? 425.0
                                      : 350.0,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: Insets.m,
                              mainAxisSpacing: Insets.m,
                              children: children,
                            ),
                          );
                        }
                        return DiffUtilSliverList<User>(
                          builder: (_, user) => OpenContainer(
                            key: ValueKey(user.id),
                            openBuilder: (_, __) => UserScreen(user),
                            closedColor: Theme.of(context).tileColor,
                            openColor: Theme.of(context).tileColor,
                            closedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            closedBuilder: (_, onTap) =>
                                UserListTile(user, onTap: onTap),
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
