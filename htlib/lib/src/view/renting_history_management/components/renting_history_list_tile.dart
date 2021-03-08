import 'package:flutter/material.dart';
import 'package:htlib/src/model/renting_history.dart';

class RentingHistoryListTile extends StatelessWidget {
  final RentingHistory rentingHistory;
  final Function() onTap;
  final bool isSmall;

  const RentingHistoryListTile(this.rentingHistory,
      {Key key, this.onTap, this.isSmall = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [Text("")],
      ),
    );
  }
}
