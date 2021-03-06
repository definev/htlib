import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';

import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserScreen extends StatefulWidget {
  final User user;
  final Function() onRemove;

  const UserScreen(
    this.user, {
    Key key,
    this.onRemove,
  }) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Image _avtImg;

  bool get isMobile => MediaQuery.of(context).size.width < 670;

  @override
  void initState() {
    super.initState();
    _avtImg = Image(
      image: CachedNetworkImageProvider(widget.user.imageUrl),
      fit: BoxFit.cover,
      height: double.maxFinite,
      width: double.maxFinite,
    );
  }

  Widget _userMobileElement(BuildContext context, String title, String value) =>
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            VSpace(Insets.sm),
            Text(
              value,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ],
        ),
      ).expanded();

  Widget _userElement(BuildContext context, String title, String value,
          {bool showDivider = true}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  "$title",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ).center(),
              ),
              Container(
                color: Theme.of(context).dividerColor,
                width: 2,
                height: 300 / 3.9,
              ),
              Flexible(
                flex: 4,
                child: Text(
                  "$value",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ).center(),
              ),
            ],
          ),
          (showDivider)
              ? Container(
                  height: 2,
                  color: Theme.of(context).dividerColor,
                  margin: EdgeInsets.symmetric(horizontal: Insets.m))
              : Container(),
        ],
      ).constrained(
          height: (300 - 2) / 3 -
              (showDivider && MediaQuery.of(context).size.height > 850
                  ? 2.0
                  : 0.0));

  double userDescHeight(BuildContext context) {
    if (MediaQuery.of(context).size.height < 730) return (300 - 2) / 4 * 1;
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
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: Insets.mid, bottom: Insets.mid),
                height: 300.0,
                child: Row(
                  children: [
                    ClipRRect(
                      child: Hero(
                        tag: widget.user.phone,
                        child: _avtImg,
                      ),
                      borderRadius:
                          BorderRadius.horizontal(left: Corners.s10Radius),
                    ).expanded(),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).tileColor,
                        border: Border.all(
                            color: Theme.of(context).dividerColor, width: 2),
                        borderRadius:
                            BorderRadius.horizontal(right: Corners.s10Radius),
                      ),
                      child: Column(
                        children: [
                          _userMobileElement(context, "Số điện thoại",
                              "${StringUtils.phoneFormat(widget.user.phone)}"),
                          Divider(),
                          _userMobileElement(
                              context, "Lớp", "${widget.user.currentClass}"),
                          Divider(),
                          _userMobileElement(context, "Chứng minh thư",
                              "${widget.user.idNumberCard}"),
                          Divider(),
                          _userMobileElement(
                              context, "Trạng thái", "${widget.user.status}"),
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
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  height: userDescHeight(context),
                  width: userDescHeight(context),
                  child: ClipRRect(
                    child: _avtImg,
                    borderRadius: Corners.s10Border,
                  ),
                ),
              ),
        if (!isMobile) HSpace(Insets.m),
        if (!isMobile)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).tileColor,
              border:
                  Border.all(color: Theme.of(context).dividerColor, width: 2),
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
            child: Scrollbar(
              thickness: 8,
              radius: Radius.circular(10),
              showTrackOnHover: true,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _userElement(context, "Số điện thoại",
                      "${StringUtils.phoneFormat(widget.user.phone)}"),
                  _userElement(context, "Lớp", "${widget.user.currentClass}"),
                  _userElement(context, "Trạng thái", "${widget.user.status}",
                      showDivider: false),
                ],
              ),
            ),
          ).expanded(),
      ],
    ).paddingSymmetric(horizontal: Insets.m).constrained(
          width: BuildUtils.specifyForMobile(
            context,
            defaultValue: PageBreak.defaultPB.tablet + 2 * Insets.m,
            mobile: MediaQuery.of(context).size.width,
          ),
        );
  }

  Widget userDesc(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedDefaultTextStyle(
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Theme.of(context).colorScheme.primary),
          duration: Durations.fast,
          child: Text(
            "${widget.user.name}",
            textAlign: TextAlign.center,
            maxLines: BuildUtils.specifyForMobile(context,
                defaultValue: 1, mobile: 2),
            overflow: TextOverflow.ellipsis,
          )
              .constrained(
                maxWidth: BuildUtils.specifyForMobile(
                  context,
                  defaultValue: PageBreak.defaultPB.tablet,
                  mobile: MediaQuery.of(context).size.width,
                ),
              )
              .padding(horizontal: Insets.sm),
        ),
        _desktopWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context);
              Get.find<UserService>().remove(widget.user);
            },
          ),
        ],
      ),
      body: Column(
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
                      Center(child: Text("SCREEN 1")),
                      Center(child: Text("SCREEN 1")),
                    ],
                  ),
                )
              ],
            ),
          ).constrained(maxWidth: PageBreak.defaultPB.tablet).expanded(),
        ],
      ).center(),
    );
  }
}
