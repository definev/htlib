import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:intl/intl.dart';

class RentingHistoryCard extends StatelessWidget {
  final RentingHistory rentingHistory;
  final Function() onTap;
  final DateTime now;

  const RentingHistoryCard({Key key, this.rentingHistory, this.onTap, this.now})
      : super(key: key);

  Tuple2<Color, IconData> _bannerElement() {
    if (rentingHistory.endAt.isBefore(now)) {
      return Tuple2(Colors.red, Icons.error);
    } else if (rentingHistory.endAt.difference(now) <=
        Duration(days: Get.find<HtlibDb>().config.warningDay)) {
      return Tuple2(Colors.yellow[600], Icons.warning);
    } else {
      return Tuple2(Colors.green, Icons.library_books);
    }
  }

  bool isNarrow(BuildContext context) =>
      MediaQuery.of(context).size.width < 1200.0;

  List<Widget> _action(BuildContext context, {double size = 56.0}) => [
        ElevatedButton(
          onPressed: () {},
          child: Center(
            child: Icon(
              Feather.phone,
              size: size - 30.0,
            ),
          ),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(Size(size, size)),
            shape: MaterialStateProperty.all(CircleBorder()),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Center(
            child: Icon(
              Feather.mail,
              size: size - 30.0,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondary),
            fixedSize: MaterialStateProperty.all(Size(size, size)),
            shape: MaterialStateProperty.all(CircleBorder()),
          ),
        ),
      ];

  Widget _banner(BuildContext context) {
    var _element = _bannerElement();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).tileColor,
        borderRadius: BorderRadius.vertical(bottom: Corners.s8Radius),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).tileColor,
              borderRadius: Corners.s8Border,
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                VSpace(Insets.m),
                Row(
                  children: [
                    HSpace(Insets.m),
                    (isNarrow(context))
                        ? Image.memory(
                            base64Decode(User.empty().image),
                            fit: BoxFit.cover,
                          ).clipRRect(all: Corners.s8).expanded()
                        : Image.memory(
                            base64Decode(User.empty().image),
                            fit: BoxFit.cover,
                            height: double.infinity,
                          )
                            .clipRRect(all: Corners.s8)
                            .paddingOnly(bottom: Insets.m)
                            .expanded(),
                    if (isNarrow(context))
                      _dayWidget(context).paddingOnly(
                        left: 10,
                        right: Insets.m,
                      )
                  ],
                ).expanded(),
                if (isNarrow(context))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _action(context, size: 50.0),
                  ).paddingOnly(top: Insets.m, bottom: Insets.m),
              ],
            ),
          ).expanded(),
          if (!isNarrow(context))
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80.0,
                  margin: EdgeInsets.only(
                    left: Insets.m,
                    right: Insets.m,
                    // right: isNarrow(context) ? Insets.m : 0.0,
                  ),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                              VSpace(Insets.sm),
                              Text(
                                "${DateFormat("dd/MM/yyyy").format(rentingHistory.createAt)}",
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
                                    .copyWith(
                                        color: Theme.of(context).primaryColor),
                              ),
                              VSpace(Insets.sm),
                              Text(
                                "${DateFormat("dd/MM/yyyy").format(rentingHistory.endAt)}",
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
                  width: 56 + 2 * Insets.m,
                  decoration: BoxDecoration(
                    color: _element.value1,
                    borderRadius: BorderRadius.only(
                      topLeft: Corners.s8Radius,
                      bottomRight: Corners.s8Radius,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _action(context),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Container _dayWidget(BuildContext context) {
    return Container(
      width: 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                "${DateFormat("dd/MM/yyyy").format(rentingHistory.createAt)}",
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          Icon(
            AntDesign.arrowdown,
            size: isNarrow(context) ? 16 : 20,
            color: Theme.of(context).colorScheme.onBackground,
          ).paddingSymmetric(vertical: Insets.m),
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
                "${DateFormat("dd/MM/yyyy").format(rentingHistory.endAt)}",
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _subtitle(BuildContext context) {
    UserService _userService = Get.find<UserService>();
    User user = _userService.getDataById(rentingHistory.borrowBy);

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
          ),
        ),
        OutlinedButton(onPressed: onTap, child: Text("Xem thêm")),
      ],
    )
        .paddingSymmetric(horizontal: Insets.m)
        .backgroundColor(Theme.of(context).tileColor)
        .clipRRect(topLeft: Corners.s8, topRight: Corners.s8)
        .flexible();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Insets.sm),
      child: Material(
        elevation: 1.5,
        color: Theme.of(context).tileColor,
        borderRadius: Corners.s8Border,
        child: InkWell(
          borderRadius: Corners.s8Border,
          onTap: onTap,
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
