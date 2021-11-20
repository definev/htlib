import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_screen.dart';
import 'package:htlib/styles.dart';
import 'package:intl/intl.dart';

enum RentingHistoryListTileMode { short, long }

class RentingHistoryListTile extends StatelessWidget {
  final RentingHistory rentingHistory;
  final Function()? onTap;
  final RentingHistoryListTileMode mode;
  final bool enableEdited;

  const RentingHistoryListTile(this.rentingHistory,
      {Key? key, this.onTap, this.mode = RentingHistoryListTileMode.long, required this.enableEdited})
      : super(key: key);

  Widget leadingIcon(int stateCode) {
    Widget? icon;
    switch (RentingHistoryStateCode.values[stateCode]) {
      case RentingHistoryStateCode.renting:
        icon = Icon(FontAwesome.calendar);
        break;
      case RentingHistoryStateCode.warning:
        icon = Icon(FontAwesome.calendar_minus_o);
        break;
      case RentingHistoryStateCode.expired:
        icon = Icon(FontAwesome.calendar_times_o);
        break;
      case RentingHistoryStateCode.returned:
        icon = Icon(FontAwesome.calendar_check_o);
        break;
    }

    return Tooltip(
      message: rentingHistoryStateCode[stateCode],
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: Theme.of(context).backgroundColor,
      openColor: Theme.of(context).backgroundColor,
      closedElevation: 0.5,
      openElevation: 1.0,
      closedBuilder: (context, onTap) => ListTile(
        tileColor: Theme.of(context).tileColor,
        onTap: onTap,
        dense: PageBreak.defaultPB.isMobile(context) ? true : false,
        isThreeLine: true,
        leading: leadingIcon(rentingHistory.state),
        title: Text(
          "Số sách mượn: ${rentingHistory.bookMap.values.fold<int>(0, (previousValue, element) => previousValue + element)}",
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "Tổng tiền: ${StringUtils.moneyFormat(rentingHistory.total)} VND",
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PageBreak.defaultPB.isMobile(context)
            ? Container(
                height: 40,
                child: ElevatedButton(onPressed: onTap, child: Icon(Icons.more_horiz)),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => onTap.call(),
                      child: Text("${DateFormat("dd/MM/yy").format(rentingHistory.createAt)}",
                          style: Theme.of(context).textTheme.button!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.arrow_right_alt), onPressed: () {}),
                  Container(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => onTap.call(),
                      child: Text("${DateFormat("dd/MM/yy").format(rentingHistory.endAt)}",
                          style: Theme.of(context).textTheme.button!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                    ),
                  ),
                ],
              ),
      ),
      closedShape: RoundedRectangleBorder(),
      openBuilder: (context, onTap) => RentingHistoryScreen(
        rentingHistory: rentingHistory,
        stateCode: RentingHistoryStateCode.values[rentingHistory.state],
        enableEdited: enableEdited,
      ),
    );
  }
}
