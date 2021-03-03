import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
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
  final UserService userService;

  const RentingHistoryCard({
    Key key,
    @required this.rentingHistory,
    @required this.onTap,
    @required this.now,
    @required this.userService,
  }) : super(key: key);

  @override
  _RentingHistoryCardState createState() => _RentingHistoryCardState();
}

class _RentingHistoryCardState extends State<RentingHistoryCard> {
  bool isWidthNarrow = false;
  bool isHeightNarrow = true;

  User user;
  Image _avtImg;

  List<Widget> _action(BuildContext context, {double size = 56.0}) => [
        ElevatedButton(
          onPressed: () => launch("tel:${user.phone}"),
          child: Icon(
            Feather.phone,
            size: size - 30.0,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(Size(size, size)),
            shape: MaterialStateProperty.all(CircleBorder()),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            alignment: Alignment.center,
          ),
        ),
        VSpace(isHeightNarrow ? 8 : 15),
        ElevatedButton(
          onPressed: () => launch("sms:${user.phone}"),
          child: Icon(
            Feather.mail,
            size: size - 30.0,
            color: Theme.of(context).colorScheme.onPrimary,
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
        mainAxisSize: isWidthNarrow ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: isWidthNarrow
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          Container(
            width: 76.0,
            margin: EdgeInsets.only(left: Insets.m, right: Insets.m),
            child: Stack(
              children: [
                Center(
                    child: Icon(
                  AntDesign.arrowdown,
                  size: 15,
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
                    if (isHeightNarrow) VSpace(Insets.m),
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
            width: (isWidthNarrow ? 50 : 56) + Insets.m,
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
              children: _action(context, size: isHeightNarrow ? 49 : 56),
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
          if (!isWidthNarrow)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).tileColor,
                borderRadius: Corners.s8Border,
              ),
              margin: EdgeInsets.only(left: Insets.m),
              padding: EdgeInsets.only(top: Insets.m, bottom: Insets.m),
              alignment: Alignment.center,
              child: _avtImg.clipRRect(all: Corners.s8),
            ).expanded(),
          isWidthNarrow
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
    Stopwatch stopwatch = new Stopwatch()..start();
    user = widget.userService.getDataById(widget.rentingHistory.borrowBy);
    _avtImg = widget.userService.imageMap[widget.rentingHistory.borrowBy];
    print('Get User Image ${stopwatch.elapsed}');
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context?.size == null) return;

      bool _isWidthNarrow = (context.size.width < 270.0) ?? isWidthNarrow;
      bool _isHeightNarrow = (context.size.height < 200.0) ?? isHeightNarrow;

      print(context.size);

      if (_isHeightNarrow != isHeightNarrow)
        setState(() => isHeightNarrow = _isHeightNarrow);
      if (_isWidthNarrow != isWidthNarrow)
        setState(() => isWidthNarrow = _isWidthNarrow);
    });

    return Padding(
      padding: EdgeInsets.all(Insets.sm),
      child: Material(
        elevation: 2,
        shadowColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black26
            : Colors.white.withOpacity(0.04),
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
