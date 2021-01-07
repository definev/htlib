import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:htlib_admin/presentation/shared/constant.dart';

class BookDetailDrawer extends StatelessWidget {
  const BookDetailDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0.w,
      height: 100.0.h,
      padding: EdgeInsets.all(5.0.h),
      color: HTlibColorTheme.background,
      child: Row(
        children: [
          Text("ABC"),
        ],
      ),
    );
  }
}
