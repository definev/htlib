import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';

import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/view/book_management/components/shortcut/shortcut_user_book_page.dart';
import 'package:htlib/src/view/renting_history_management/components/shortcut/shortcut_user_renting_history_page.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/_internal/styled_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserScreen extends StatefulWidget {
  final User user;
  final bool primary;

  const UserScreen(this.user, {Key? key, this.primary = false}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool get isMobile => MediaQuery.of(context).size.width < 670;

  Widget _userMobileElement(BuildContext context, String title, String value) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(height: 1),
            Column(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                VSpace(Insets.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          height: 1.15,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Container(height: 1, color: Theme.of(context).dividerColor),
          ],
        ),
      ).constrained(height: (300 - 2) / 4);

  Widget _userElement(BuildContext context, String title, String value, {bool showDivider = true}) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  "$title",
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).colorScheme.secondary),
                ).center(),
              ),
              Container(
                color: Theme.of(context).dividerColor,
                width: 2,
                height: 300 / 7,
              ),
              Flexible(
                flex: 4,
                child: Text(
                  "$value",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Theme.of(context).colorScheme.onBackground),
                ).center(),
              ),
            ],
          ),
          (showDivider)
              ? Container(
                  height: 2, color: Theme.of(context).dividerColor, margin: EdgeInsets.symmetric(horizontal: Insets.m))
              : Container(),
        ],
      ).constrained(height: (300 - 2) / 4 - (showDivider && MediaQuery.of(context).size.height > 850 ? 2.0 : 0.0));

  double userDescHeight(BuildContext context) {
    if (MediaQuery.of(context).size.height < 450) return (300 - 2) / 4 * 1;
    if (MediaQuery.of(context).size.height < 600) return (300 - 2) / 4 * 2;
    if (MediaQuery.of(context).size.height < 850) return (300 - 2) / 4 * 3;
    return 300;
  }

  Widget _desktopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (isMobile)
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: Corners.s10Border,
                  boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(.1), blurRadius: 10)],
                ),
                margin: EdgeInsets.only(top: Insets.mid, bottom: Insets.m),
                height: userDescHeight(context),
                child: Row(
                  children: [
                    ClipRRect(
                      child: Hero(
                        tag: widget.user.phone,
                        child: Image(
                          image: CachedNetworkImageProvider(widget.user.imageUrl!),
                          fit: BoxFit.cover,
                          height: double.maxFinite,
                          width: double.maxFinite,
                        ),
                      ),
                      borderRadius: BorderRadius.horizontal(left: Corners.s10Radius),
                    ).expanded(),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        border: Border.all(color: Theme.of(context).dividerColor, width: 2),
                        borderRadius: BorderRadius.horizontal(right: Corners.s10Radius),
                      ),
                      height: userDescHeight(context),
                      child: ListView(
                        children: [
                          _userMobileElement(context, "Số điện thoại", "${StringUtils.phoneFormat(widget.user.phone)}"),
                          _userMobileElement(context, "Lớp", "${widget.user.className}"),
                          _userMobileElement(context, "Địa chỉ", "${widget.user.address}"),
                          _userMobileElement(context, "Trạng thái", "${widget.user.status}"),
                        ],
                      ),
                    ).expanded(),
                  ],
                ),
              ).expanded()
            : Hero(
                tag: widget.user.phone,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: Corners.s10Border,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  height: userDescHeight(context),
                  width: userDescHeight(context),
                  child: ClipRRect(
                    child: Image(
                      image: CachedNetworkImageProvider(widget.user.imageUrl!),
                      fit: BoxFit.cover,
                      height: double.maxFinite,
                      width: double.maxFinite,
                    ),
                    borderRadius: Corners.s10Border,
                  ),
                ),
              ),
        if (!isMobile) HSpace(Insets.m),
        if (!isMobile)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).tileColor,
              border: Border.all(color: Theme.of(context).dividerColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.1),
                  blurRadius: 10,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(vertical: Insets.l),
            height: userDescHeight(context),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _userElement(context, "Số điện thoại", "${StringUtils.phoneFormat(widget.user.phone)}"),
                _userElement(context, "Lớp", "${widget.user.className}"),
                _userElement(context, "Địa chỉ", "${widget.user.address}"),
                _userElement(context, "Trạng thái", "${widget.user.status}", showDivider: false),
              ],
            ),
          ).expanded(),
      ],
    ).paddingSymmetric(horizontal: Insets.m).constrained(
          width: BuildUtils.specifyForMobile(
            context,
            defaultValue: PageBreak.defaultPB.tablet + 2 * Insets.m,
            mobile: MediaQuery.of(context).size.width,
          )!,
        );
  }

  Widget userDesc(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedDefaultTextStyle(
          style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).colorScheme.primary),
          duration: Durations.fast,
          child: Text(
            "${widget.user.name}",
            textAlign: TextAlign.center,
            maxLines: BuildUtils.specifyForMobile(context, defaultValue: 1, mobile: 2),
            overflow: TextOverflow.ellipsis,
          )
              .constrained(
                maxWidth: BuildUtils.specifyForMobile(
                  context,
                  defaultValue: PageBreak.defaultPB.tablet,
                  mobile: MediaQuery.of(context).size.width,
                )!,
              )
              .padding(horizontal: Insets.sm),
        ),
        _desktopWidget(),
      ],
    );
  }

  AdminService? adminService;

  @override
  void initState() {
    super.initState();
    try {
      adminService = Get.find<AdminService>();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.primary
          ? (PageBreak.defaultPB.isMobile(context)
              ? AppBar(
                  title: Text('Trang cá nhân'),
                  centerTitle: true,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                )
              : PreferredSize(
                  preferredSize: Size.fromHeight(59.0),
                  child: Container(
                    height: 59.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark],
                      ),
                    ),
                  ),
                ))
          : AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await Get.find<UserService>().removeAsync(widget.user);
                    Get.find<AdminService>().editActiveUserInMornitor(widget.user.className, remove: 1);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            userDesc(context).padding(
              vertical: BuildUtils.getResponsive(
                context,
                desktop: Insets.xl,
                tablet: Insets.l,
                mobile: Insets.m,
                tabletPortrait: Insets.mid,
              ),
            ),
            Container(
              height: 1.5,
              color: Theme.of(context).dividerColor,
              constraints: BoxConstraints(maxWidth: PageBreak.defaultPB.tablet),
            ),
            DefaultTabController(
              initialIndex: 0,
              length: 2,
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      return TabBar(
                        tabs: [
                          Tab(
                            icon: Icon(Feather.book_open),
                            text: "Sách đang mượn",
                            iconMargin: EdgeInsets.only(bottom: Insets.sm),
                          ),
                          Tab(
                            icon: Icon(Feather.file_text),
                            text: "Lịch sử cho mượn",
                            iconMargin: EdgeInsets.only(bottom: Insets.sm),
                          ),
                        ],
                        onTap: (value) {},
                      );
                    },
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ShortcutUserBookPage(widget.user),
                        ShortcutUserRentingHistoryPage(widget.user),
                      ],
                    ),
                  )
                ],
              ),
            ).constrained(maxWidth: PageBreak.defaultPB.tablet).expanded(),
          ],
        ).center(),
      ),
    );
  }
}
