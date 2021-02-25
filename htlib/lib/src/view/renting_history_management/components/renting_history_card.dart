import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/styles.dart';
import 'package:styled_widget/styled_widget.dart';

class RentingHistoryCard extends StatelessWidget {
  final RentingHistory rentingHistory;
  final Function() onTap;
  final DateTime now;

  const RentingHistoryCard({Key key, this.rentingHistory, this.onTap, this.now})
      : super(key: key);

  Tuple2<Color, IconData> _bannerElement() {
    if (rentingHistory.endAt.isBefore(now)) {
      return Tuple2(Colors.red, Icons.error);
    } else if (rentingHistory.endAt.difference(now) <=
        Duration(days: Get.find<HtlibDb>().config.warningDay)) {
      return Tuple2(Colors.yellow[600], Icons.warning);
    } else {
      return Tuple2(Colors.green, Icons.library_books);
    }
  }

  Widget _banner(BuildContext context) {
    var _element = _bannerElement();
    return Container(
      decoration: BoxDecoration(
        color: _element.value1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
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
    return Container(
      margin: EdgeInsets.all(Insets.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Theme.of(context).primaryColor.withOpacity(0.15),
          )
        ],
      ),
      child: Column(
        children: [
          _banner(context),
          Text("Mượn").flexible(),
        ],
      ),
    );
  }
}
