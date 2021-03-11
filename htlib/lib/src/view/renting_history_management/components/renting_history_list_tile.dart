import 'package:flutter/material.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/styles.dart';
import 'package:intl/intl.dart';

class RentingHistoryListTile extends StatelessWidget {
  final RentingHistory rentingHistory;
  final Function() onTap;
  final bool isSmall;

  const RentingHistoryListTile(this.rentingHistory,
      {Key key, this.onTap, this.isSmall = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).tileColor,
      onTap: () => onTap?.call(),
      dense: PageBreak.defaultPB.isMobile(context) ? true : false,
      leading: Icon(Icons.history),
      title: Text(
        "Số sách mượn: ${rentingHistory.bookList.length}",
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "Tổng tiền: ${rentingHistory.total}",
        overflow: TextOverflow.ellipsis,
      ),
      trailing: SizedBox(
        width: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              width: 120,
              child: ElevatedButton(
                onPressed: () => onTap?.call(),
                child: Text(
                    "${DateFormat("d/M/y").format(rentingHistory.createAt)}",
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )),
              ),
            ),
            Container(
              height: 40,
              width: 120,
              child: ElevatedButton(
                onPressed: () => onTap?.call(),
                child:
                    Text("${DateFormat("d/M/y").format(rentingHistory.endAt)}",
                        style: Theme.of(context).textTheme.button.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
