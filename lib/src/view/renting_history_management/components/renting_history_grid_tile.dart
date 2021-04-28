import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/launcher_utils.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_screen.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/_internal/styled_widget.dart';
import 'package:intl/intl.dart';

class RentingHistoryGridTile extends StatefulWidget {
  final RentingHistory rentingHistory;
  final RentingHistoryStateCode stateCode;
  final Function() onTap;
  final DateTime now;
  final UserService userService;

  const RentingHistoryGridTile({
    Key? key,
    required this.rentingHistory,
    required this.onTap,
    required this.now,
    required this.userService,
    required this.stateCode,
  }) : super(key: key);

  @override
  _RentingHistoryGridTileState createState() => _RentingHistoryGridTileState();
}

class _RentingHistoryGridTileState extends State<RentingHistoryGridTile> {
  bool isWidthNarrow = false;
  bool isHeightNarrow = true;

  late User user;

  Color? tileColor(BuildContext context) => Color.lerp(
      Theme.of(context).tileColor, Theme.of(context).primaryColor, 0.00);

  List<Widget> _action(BuildContext context, {double size = 56.0}) => [
        ElevatedButton(
          onPressed: () => LauncherUtils.call(user.phone),
          child: Icon(
            Feather.phone,
            size: size - 30.0,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(size, size)),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            alignment: Alignment.center,
          ),
        ),
        VSpace(isHeightNarrow ? 8 : 15),
        ElevatedButton(
          onPressed: () => LauncherUtils.message(user.phone),
          child: Icon(
            Feather.mail,
            size: size - 30.0,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(size, size)),
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondary),
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
            margin: EdgeInsets.only(left: Insets.m, right: Insets.m),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Mượn ngày",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
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
                          .bodyText2!
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
        borderRadius: BorderRadius.vertical(bottom: Corners.s8Radius),
      ),
      child: Row(
        children: [
          if (!isWidthNarrow)
            Container(
              decoration: BoxDecoration(borderRadius: Corners.s8Border),
              margin: EdgeInsets.only(left: Insets.m),
              padding: EdgeInsets.only(top: Insets.m, bottom: Insets.m),
              alignment: Alignment.center,
              child: ClipPath(
                clipper: ShapeBorderClipper(
                    shape: Theme.of(context).floatingActionButtonTheme.shape!),
                child: Image(
                  image: CachedNetworkImageProvider(user.imageUrl!),
                  fit: BoxFit.cover,
                  height: double.maxFinite,
                  width: double.maxFinite,
                ),
              ),
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
                      .bodyText2!
                      .copyWith(color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "${StringUtils.phoneFormat(user.phone)}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
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
        .clipRRect(topLeft: Corners.s8, topRight: Corners.s8)
        .flexible();
  }

  @override
  void initState() {
    super.initState();
    Stopwatch stopwatch = new Stopwatch()..start();
    user = widget.userService.getDataById(widget.rentingHistory.borrowBy);
    print('Get User Image ${stopwatch.elapsed}');
  }

  Widget gridTile(Function() action) => Card(
        color: tileColor(context),
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        semanticContainer: true,
        child: InkWell(
          onTap: () {
            action();
            widget.onTap.call();
          },
          child: Column(
            children: [
              _subtitle(context),
              Container(height: 1, color: Theme.of(context).dividerColor),
              Flexible(flex: 3, child: _banner(context)),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (context.size == null) return;

      bool _isWidthNarrow = (context.size!.width < 270.0);
      bool _isHeightNarrow = (context.size!.height < 200.0);

      if (_isHeightNarrow != isHeightNarrow)
        setState(() => isHeightNarrow = _isHeightNarrow);
      if (_isWidthNarrow != isWidthNarrow)
        setState(() => isWidthNarrow = _isWidthNarrow);
    });

    return OpenContainer(
      closedColor: Theme.of(context).backgroundColor,
      openColor: Theme.of(context).backgroundColor,
      closedElevation: 0.0,
      openElevation: 1.0,
      closedBuilder: (context, action) => gridTile(action),
      openBuilder: (context, action) => RentingHistoryScreen(
        stateCode: widget.stateCode,
        userService: widget.userService,
        rentingHistory: widget.rentingHistory,
        onTap: action,
        enableEdited: true,
      ),
    ).padding(all: 3);
  }
}
