import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/view/book_management/components/shortcut/shortcut_renting_history_book_page.dart';
import 'package:htlib/styles.dart';
import 'package:intl/intl.dart';
import 'package:htlib/_internal/styled_widget.dart';

class RentingHistoryScreen extends StatefulWidget {
  final RentingHistory rentingHistory;
  final RentingHistoryStateCode stateCode;
  final UserService? userService;
  final Function() onTap;
  final bool enableEdited;

  const RentingHistoryScreen({
    Key? key,
    required this.rentingHistory,
    required this.onTap,
    required this.userService,
    required this.stateCode,
    required this.enableEdited,
  }) : super(key: key);

  @override
  _RentingHistoryScreenState createState() => _RentingHistoryScreenState();
}

class _RentingHistoryScreenState extends State<RentingHistoryScreen> {
  late User user;
  late RentingHistory rentingHistory;
  RentingHistoryService rentingHistoryService = Get.find();

  Widget _rentingElement(BuildContext context, String title, String value,
      {bool showDivider = true}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        Row(
          children: [
            Flexible(
              flex: 2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 2),
                  Text(
                    "$title",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
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
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
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
    ).constrained(height: (300 - 4) / 4);
  }

  double rentingDescHeight(BuildContext context) {
    if (MediaQuery.of(context).size.height < 730) return (300 - 2) / 4 * 2;
    if (MediaQuery.of(context).size.height < 850) return (300 - 2) / 4 * 3;
    return 300;
  }

  Widget rentingDesc(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedDefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Theme.of(context).colorScheme.primary),
            duration: Durations.fast,
            child: Text(
              "${user.name}",
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
                  )!,
                )
                .padding(horizontal: Insets.sm),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).tileColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.1),
                  blurRadius: 30,
                ),
              ],
              border:
                  Border.all(color: Theme.of(context).dividerColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(
                vertical: Insets.l, horizontal: Insets.mid),
            height: rentingDescHeight(context),
            width: BuildUtils.specifyForMobile(
              context,
              defaultValue: PageBreak.defaultPB.tablet,
              mobile: MediaQuery.of(context).size.width,
            ),
            child: Scrollbar(
              thickness: 8,
              radius: Radius.circular(10),
              showTrackOnHover: true,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _rentingElement(context, "Giá trị",
                      "${StringUtils.moneyFormat(rentingHistory.total)} VND"),
                  _rentingElement(context, "Trạng thái",
                      "${rentingHistoryStateCode[rentingHistory.state]}"),
                  _rentingElement(context, "Ngày mượn",
                      "${DateFormat.yMMMMEEEEd("vi").format(rentingHistory.createAt)}"),
                  _rentingElement(context, "Hạn trả",
                      "${DateFormat.yMMMMEEEEd("vi").format(rentingHistory.endAt)}",
                      showDivider: false),
                ],
              ),
            ),
          ),
        ],
      );

  @override
  void initState() {
    super.initState();
    rentingHistory = widget.rentingHistory;
    user = widget.userService!.getDataById(rentingHistory.borrowBy);
    if (widget.stateCode.index != rentingHistory.state) {
      rentingHistory = rentingHistory.copyWith(state: widget.stateCode.index);
      rentingHistoryService.edit(rentingHistory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: widget.enableEdited
            ? [
                IconButton(
                  icon: Icon(Icons.check_box_rounded),
                  onPressed: () {
                    rentingHistoryService.returnAsync(rentingHistory);
                    Navigator.pop(context);
                  },
                  tooltip: "Đánh dấu đã trả",
                )
              ]
            : [],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          rentingDesc(context).padding(
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
            constraints: BoxConstraints(maxWidth: PageBreak.defaultPB.tablet!),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              accentColor: Colors.transparent,
              focusColor: Colors.black12,
              highlightColor: Colors.grey.withOpacity(0.1),
              tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
                    unselectedLabelColor: Colors.grey,
                    indicator: UnderlineTabIndicator(
                      insets: EdgeInsets.zero,
                      borderSide: BorderSide(
                          width: 2.0, color: Theme.of(context).primaryColor),
                    ),
                    labelColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyles.Body1,
                    unselectedLabelStyle: TextStyles.Body1,
                  ),
            ),
            child: DefaultTabController(
              initialIndex: 0,
              length: 1,
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      return TabBar(
                        tabs: [
                          Tab(
                            icon: Icon(Feather.book_open),
                            text: "Sách mượn",
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
                        ShortcutRentingHistoryBookPage(rentingHistory),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ).constrained(maxWidth: PageBreak.defaultPB.tablet!).expanded(),
        ],
      ).center(),
    );
  }
}
