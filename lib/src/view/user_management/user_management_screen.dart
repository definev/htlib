import 'package:animations/animations.dart';
import 'package:diffutil_sliverlist/diffutil_sliverlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/sliver_indicator.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/services/state_management/list/list_cubit.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/utils/app_config.dart';
import 'package:htlib/src/utils/painter/logo.dart';
import 'package:htlib/src/view/user_management/components/user_bottom_bar.dart';
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
  AdminService adminService = Get.find<AdminService>();

  ChildLayoutMode mode = ChildLayoutMode.list;

  bool isInit = false;

  GlobalKey<SliverAnimatedListState> listKey = GlobalKey<SliverAnimatedListState>();

  List<Widget> get actions {
    switch (adminService.currentUser.value.adminType) {
      case AdminType.librarian:
        return [
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
      case AdminType.mornitor:
        return [
          Text(
            '${adminService.currentUser.value.activeMemberNumber}  /  ${adminService.currentUser.value.memberNumber}',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          HSpace(Insets.m),
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
        ];
      case AdminType.tester:
        return [];
    }
  }

  Widget _appBar() {
    return HtlibSliverAppBar(
      bottom: UserBottomBar(actions: actions),
      title: AppConfig.tabUser,
      actions: actions,
    );
  }

  late VoidCallback onUserChanged;

  @override
  void initState() {
    super.initState();
    onUserChanged = () => setState(() {});
    adminService.currentUser.addListener(onUserChanged);
  }

  @override
  void dispose() {
    adminService.currentUser.removeListener(onUserChanged);
    super.dispose();
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
                        if (_list.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: LogoBanner(content: "Chưa có ${AppConfig.tabUser.toLowerCase()}"),
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
