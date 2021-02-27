import 'package:flutter/material.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingBottomBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> actions;

  const SettingBottomBar({
    Key key,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Container(height: 1, color: Theme.of(context).secondaryHeaderColor),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
