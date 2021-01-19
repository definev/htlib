import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/styled_components/buttons/secondary_btn.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:htlib/styles.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrDialog extends StatelessWidget {
  final BookBase bookBase;

  const QrDialog({Key key, this.bookBase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          VSpace(Insets.l),
          TextStyles.H1Text("Mã QR"),
          VSpace(Insets.m),
          QrImage(
            data: "${bookBase.isbn}",
            backgroundColor: Colors.white,
            size: 200,
          ),
          VSpace(Insets.m),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SecondaryTextBtn("Cancel", onPressed: () => Get.back()),
              HSpace(Insets.m),
              SecondaryTextBtn(
                "OK",
                onPressed: () {},
              ),
            ],
          ),
          VSpace(Insets.l),
        ],
      ).constrained(width: 300),
    ).center();
  }
}
