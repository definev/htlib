import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/borrowing_history.dart';
import 'package:styled_widget/styled_widget.dart';

class BorrowingHistoryCard extends StatelessWidget {
  final BorrowingHistory borrowingHistory;
  final Function() onTap;
  final DateTime now;

  const BorrowingHistoryCard(
      {Key key, this.borrowingHistory, this.onTap, this.now})
      : super(key: key);

  Tuple2<Color, IconData> _bannerElement() {
    if (borrowingHistory.endAt.isBefore(now)) {
      return Tuple2(Colors.red, Icons.error);
    } else if (borrowingHistory.endAt.difference(now) <=
        Duration(days: Get.find<HtlibDb>().config.warningDay)) {
      return Tuple2(Colors.yellow[600], Icons.warning);
    } else {
      return Tuple2(Colors.green, Icons.library_books);
    }
  }

  Widget _banner(BuildContext context) {
    var _element = _bannerElement();
    return Container(
      color: _element.value1,
      child: Center(
        child: Icon(
          _element.value2,
          size: Theme.of(context).textTheme.headline1.fontSize,
        ),
      ),
    ).flexible(flex: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.15),
      child: Column(
        children: [
          _banner(context),
          Text("Mượn").flexible(),
        ],
      ),
    );
  }
}
