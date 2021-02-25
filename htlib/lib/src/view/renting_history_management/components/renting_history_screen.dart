import 'package:flutter/material.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/model/renting_history.dart';

class RentingHistoryScreen extends StatefulWidget {
  final RentingHistory rentingHistory;
  final Function() onTap;
  final DateTime now;

  const RentingHistoryScreen(
      {Key key, this.rentingHistory, this.onTap, this.now})
      : super(key: key);
  @override
  _RentingHistoryScreenState createState() => _RentingHistoryScreenState();
}

class _RentingHistoryScreenState extends State<RentingHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: PageBreak.defaultPB.isDesktop(context)
                  ? 1200
                  : PageBreak.defaultPB.isTablet(context)
                      ? PageBreak.defaultPB.mobile
                      : MediaQuery.of(context).size.width,
            ),
            child: Column(
              children: [
                Text(widget.rentingHistory.endAt.toIso8601String()),
              ],
            ),
          ),
        ));
  }
}
