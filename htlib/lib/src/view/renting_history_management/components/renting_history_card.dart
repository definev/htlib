import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class RentingHistoryCard extends StatefulWidget {
  final RentingHistory rentingHistory;
  final Function() onTap;
  final DateTime now;

  const RentingHistoryCard({Key key, this.rentingHistory, this.onTap, this.now})
      : super(key: key);

  @override
  _RentingHistoryCardState createState() => _RentingHistoryCardState();
}

class _RentingHistoryCardState extends State<RentingHistoryCard> {
  bool isNarrow = false;

  UserService _userService;
  User user;

  List<Widget> _action(BuildContext context, {double size = 56.0}) => [
        ElevatedButton(
          onPressed: () => launch("tel:${user.phone}"),
          child: Icon(
            Feather.phone,
            size: size - 30.0,
          ),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(Size(size, size)),
            shape: MaterialStateProperty.all(CircleBorder()),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            alignment: Alignment.center,
          ),
        ),
        VSpace(isNarrow ? 8 : 15),
        ElevatedButton(
          onPressed: () => launch("sms:${user.phone}"),
          child: Icon(
            Feather.mail,
            size: size - 30.0,
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondary),
            fixedSize: MaterialStateProperty.all(Size(size, size)),
            shape: MaterialStateProperty.all(CircleBorder()),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            alignment: Alignment.center,
          ),
        ),
      ];

  Widget _buildContact(BuildContext context) => Row(
        mainAxisSize: isNarrow ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment:
            isNarrow ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          Container(
            width: 76.0,
            margin: EdgeInsets.only(left: Insets.m, right: Insets.m),
            child: Stack(
              children: [
                Center(
                    child: Icon(
                  AntDesign.arrowdown,
                  size: PageBreak.defaultPB.isMobile(context) ? 16 : 20,
                  color: Theme.of(context).colorScheme.onBackground,
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Mượn ngày",
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        VSpace(Insets.sm),
                        Text(
                          "${DateFormat("dd/MM/yyyy").format(widget.rentingHistory.createAt)}",
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Ngày trả",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                        VSpace(Insets.sm),
                        Text(
                          "${DateFormat("dd/MM/yyyy").format(widget.rentingHistory.endAt)}",
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: (isNarrow ? 50 : 56) + Insets.m,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Corners.s8Radius,
                bottomRight: Corners.s8Radius,
              ),
            ),
            padding: EdgeInsets.only(right: Insets.m),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _action(context, size: isNarrow ? 50 : 56),
            ),
          ),
        ],
      );

  Widget _banner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).tileColor,
        borderRadius: BorderRadius.vertical(bottom: Corners.s8Radius),
      ),
      child: Row(
        children: [
          if (!isNarrow)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).tileColor,
                borderRadius: Corners.s8Border,
              ),
              margin: EdgeInsets.only(left: Insets.m),
              padding: EdgeInsets.only(top: Insets.m, bottom: Insets.m),
              alignment: Alignment.center,
              child: Image.memory(
                base64Decode(User.empty().image),
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ).clipRRect(all: Corners.s8),
            ).expanded(),
          isNarrow
              ? Expanded(child: _buildContact(context))
              : _buildContact(context)
        ],
      ),
    );
  }

  Widget _subtitle(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user.name}",
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              VSpace(Insets.sm),
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: "SDT: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "${StringUtils.numberPhomeFormat(user.phone)}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ).paddingOnly(right: Insets.m),
        ),
        OutlinedButton(onPressed: widget.onTap, child: Text("Xem thêm")),
      ],
    )
        .paddingSymmetric(horizontal: Insets.m)
        .backgroundColor(Theme.of(context).tileColor)
        .clipRRect(topLeft: Corners.s8, topRight: Corners.s8)
        .flexible();
  }

  @override
  void initState() {
    super.initState();
    _userService = Get.find<UserService>();
    user = _userService.getDataById(widget.rentingHistory.borrowBy);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool _isNarrow = (context.size.width < 270.0) ?? isNarrow;
      if (_isNarrow != isNarrow) setState(() => isNarrow = _isNarrow);
    });

    return Padding(
      padding: EdgeInsets.all(Insets.sm),
      child: Material(
        elevation: 1.5,
        color: Theme.of(context).tileColor,
        borderRadius: Corners.s8Border,
        child: InkWell(
          borderRadius: Corners.s8Border,
          onTap: widget.onTap,
          child: Column(
            children: [
              _subtitle(context),
              Container(height: 1, color: Theme.of(context).dividerColor),
              Flexible(
                flex: 3,
                child: _banner(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
