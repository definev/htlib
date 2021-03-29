import 'package:flutter/material.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

class RentingHistoryBottomBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> actions;

  const RentingHistoryBottomBar({
    Key key,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.fastest,
      height: preferredSize.height,
      child: Column(
        children: [
          Container(
              height: 1,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6)),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (actions != null) Row(children: [...actions]),
              ],
            ),
          ).expanded(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(59.0);
}
