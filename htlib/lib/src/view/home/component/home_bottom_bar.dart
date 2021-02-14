import 'package:flutter/material.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeBottomBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> actions;

  const HomeBottomBar({Key key, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.fastest,
      height: preferredSize.height,
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Container(
            height: 1,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.m),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (actions != null) ...actions,
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
