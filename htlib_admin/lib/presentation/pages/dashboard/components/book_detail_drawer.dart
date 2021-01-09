import 'package:flutter/material.dart';
import 'package:htlib_admin/presentation/shared/constant.dart';
import 'package:sized_context/sized_context.dart';

class BookDetailDrawer extends StatelessWidget {
  const BookDetailDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 400 > context.widthPct(.2) ? 400 : context.widthPct(.2),
        maxHeight: context.heightPx,
        minWidth: 400,
      ),
      padding: EdgeInsets.all(context.heightPct(0.05)),
      color: HTlibColorTheme.background,
      alignment: Alignment.center,
      child: Row(
        children: [
          Text("ABC"),
        ],
      ),
    );
  }
}
