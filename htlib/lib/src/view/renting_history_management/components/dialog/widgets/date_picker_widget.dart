import 'package:flutter/material.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime endAt) onPickDateTime;
  final DateTime dateTime;

  const DatePickerWidget({Key key, this.onPickDateTime, this.dateTime})
      : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VSpace(Insets.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 56,
              child: IconButton(
                icon: Icon(Icons.calendar_today_outlined),
                onPressed: () async {
                  DateTime now = DateTime.now();

                  widget.onPickDateTime(await showDatePicker(
                    context: context,
                    firstDate: now.add(1.days),
                    lastDate: now.add(60.days),
                    initialDate: now.add(1.days),
                  ));
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: widget.dateTime == null ? 2 * Insets.sm + 2 : 0),
              child: Text(
                  "${widget.dateTime == null ? "Hạn mượn" : DateFormat("dd/MM/yyyy").format(widget.dateTime)}"),
            ),
            if (widget.dateTime != null)
              ElevatedButton(
                child: Text("Xóa"),
                onPressed: () async {
                  widget.onPickDateTime(null);
                  setState(() {});
                },
              ).paddingOnly(right: Insets.m + 2 * Insets.xs),
          ],
        ),
      ],
    );
  }
}
