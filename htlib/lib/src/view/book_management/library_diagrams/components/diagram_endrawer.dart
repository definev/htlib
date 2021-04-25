import 'package:flutter/material.dart';
import 'package:htlib/_internal/page_break.dart';

class DiagramEndDrawer extends StatefulWidget {
  @override
  _DiagramEndDrawerState createState() => _DiagramEndDrawerState();
}

class _DiagramEndDrawerState extends State<DiagramEndDrawer> {
  @override
  Widget build(BuildContext context) {
    if (PageBreak.defaultPB.isDesktop(context)) {
      return Drawer(
        child: ListView(
          children: [
            Text(
              "Chỉnh sửa",
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.background,
    );
  }
}
