import 'package:flutter/material.dart';
import 'package:htlib/src/view/home/home_screen.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/_internal/styled_widget.dart';

class UserBottomBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget>? actions;
  final SortingState sortingState;
  final SortingMode sortingMode;

  const UserBottomBar({
    Key? key,
    this.actions,
    this.sortingState = SortingState.noSort,
    this.sortingMode = SortingMode.lth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.fastest,
      height: preferredSize.height,
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Container(height: 1, color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6)),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (actions != null) Row(children: [...actions!]),
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
