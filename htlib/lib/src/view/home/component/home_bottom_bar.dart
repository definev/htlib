import 'package:flutter/material.dart';
import 'package:htlib/styles.dart';

class HomeBottomBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.fastest,
      color: Colors.white38,
      height: preferredSize.height,
      child: Row(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}
