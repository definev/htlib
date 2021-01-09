import 'package:flutter/material.dart';
import 'package:sized_context/sized_context.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.widthPct(.2),
      height: context.heightPx,
      color: Colors.white,
    );
  }
}
