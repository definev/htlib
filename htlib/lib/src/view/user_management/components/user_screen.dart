import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';

import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

class UserScreen extends StatefulWidget {
  final User user;
  final Uint8List image;
  final Function() onRemove;

  const UserScreen(this.user, {Key key, this.onRemove, this.image})
      : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Image _avtImg;

  @override
  void initState() {
    super.initState();
    _avtImg = Image.memory(
          widget.image,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ) ??
        Image.memory(
          base64Decode(widget.user.image),
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        );
  }

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
    if (MediaQuery.of(context).size.height < 730) return (300 - 2) / 4 * 2;
    if (MediaQuery.of(context).size.height < 850) return (300 - 2) / 4 * 3;
    return 300;
  }

  Widget _desktopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
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
          child: Hero(
            tag: widget.user.phone,
            child: ClipRRect(
              child: _avtImg,
              borderRadius: Corners.s10Border,
            ),
          ),
        ),
        HSpace(Insets.m),
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
          child: Scrollbar(
            thickness: 8,
            radius: Radius.circular(10),
            showTrackOnHover: true,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _userElement(context, "Số điện thoại", "${widget.user.phone}"),
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