import 'package:animations/animations.dart';
import 'package:diffutil_sliverlist/diffutil_sliverlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/sliver_indicator.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/state_management/list/list_cubit.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/utils/painter/logo.dart';
import 'package:htlib/src/view/user_management/components/user_bottom_bar.dart';
import 'package:htlib/src/view/home/home_screen.dart';
import 'package:htlib/src/view/user_management/components/user_grid_tile.dart';
import 'package:htlib/src/view/user_management/components/user_list_tile.dart';
import 'package:htlib/src/view/user_management/components/user_screen.dart';
import 'package:htlib/src/view/user_management/printing/user_select_printing_screen.dart';
import 'package:htlib/src/widget/htlib_sliver_app_bar.dart';
import 'package:htlib/styles.dart';

part 'user_management_binding.dart';

class UserManagementScreen extends StatefulWidget {
  static String route = "/home/users";

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  int index = 0;
  UserService? userService;
  SortingState _sortingState = SortingState.noSort;
  SortingMode _sortingMode = SortingMode.lth;

  ChildLayoutMode mode = ChildLayoutMode.list;

  bool isInit = false;

  GlobalKey<SliverAnimatedListState> listKey = GlobalKey<SliverAnimatedListState>();

  List<Widget> get actions => [
        IconButton(
          icon: Icon(Icons.print),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            showModal(
              context: context,
              builder: (context) => UserSelectPrintingScreen(),
            );
          },
          tooltip: "In hàng loạt",
        ),
        IconButton(
          icon: Icon(
            mode == ChildLayoutMode.list ? Feather.grid : Feather.list,
            key: ValueKey("Viewmode: $mode"),
          ),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            setState(() => mode = ChildLayoutMode.values[(mode.index + 1) % 2]);
          },
          tooltip: mode == ChildLayoutMode.list ? "Dạng lưới" : "Dạng danh sách",
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(Feather.search),
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {},
            tooltip: "Tìm kiếm người mượn",
          ),
        ),
      ];

  Widget _appBar() {
    return HtlibSliverAppBar(
      bottom: UserBottomBar(
        actions: actions,
        sortingState: _sortingState,
        sortingMode: _sortingMode,
        onSort: (state) => setState(() => _sortingState = state),
        onChangedMode: (mode) => setState(() => _sortingMode = mode),
      ),
      title: AppConfig.tabUser,
      actions: actions,
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
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: CustomScrollView(
        slivers: [
          _appBar(),
          userService == null
              ? SliverIndicator()
              : BlocBuilder<ListCubit<User>, ListState<User>>(
                  bloc: userService!.userListCubit,
                  builder: (context, state) {
                    return state.maybeWhen<Widget>(
                      initial: () => SliverIndicator(),
                      waiting: () => SliverIndicator(),
                      done: (_list) {
                        if (_sortingState != SortingState.noSort) {
                          _list.sort((b1, b2) {
                            if (_sortingMode == SortingMode.htl) {
                              User swap = b1;
                              b1 = b2;
                              b2 = swap;
                            }
                            return _sortingState == SortingState.alphabet ? b1.name.compareTo(b2.name) : b1.quantity.compareTo(b2.quantity);
                          });
                        }

                        if (_list.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: LogoBanner(content: "Chưa có người dùng"),
                            ),
                          );
                        }
                        if (mode == ChildLayoutMode.grid) {
                          List<Widget> children = [];
                          for (int i = 0; i < _list.length; i++) {
                            children.add(
                              UserGridTile(
                                _list[i],
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
                              maxCrossAxisExtent: PageBreak.defaultPB.isMobile(context) ? 425.0 : 350.0,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: Insets.m,
                              mainAxisSpacing: Insets.m,
                              children: children,
                            ),
                          );
                        }
                        return DiffUtilSliverList<User>(
                          builder: (_, user) => UserListTile(user),
                          items: _list as List<User>,
                          insertAnimationBuilder: (context, animation, child) => FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                          removeAnimationBuilder: (context, animation, child) => FadeTransition(
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
