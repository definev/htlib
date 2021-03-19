import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/utils.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/styles.dart';

class ScannerScreen extends StatelessWidget {
  Widget button(BuildContext context,
      {Function() onPressed, IconData iconData, String text}) {
    return ElevatedButton(
      style: ButtonStyle(),
      onPressed: onPressed,
      child: SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width / 2 - 3 * Insets.mid,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 50),
            VSpace(Insets.m),
            Text(
              text,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<HtlibApi>().user.onSearchDone();
        Get.find<HtlibApi>().book.onSearchDone();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Quét mã",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              button(
                context,
                onPressed: () async {
                  String code = await Utils.scanQrcode(context);
                  await Get.find<HtlibApi>().user.addSearch(code);
                  Future.delayed(1.seconds,
                      () => Get.find<HtlibApi>().user.onSearchDone());
                },
                iconData: Feather.user,
                text: "Mã người mượn",
              ),
              button(
                context,
                onPressed: () async {
                  String code = await Utils.scanBarcode(context);
                  await Get.find<HtlibApi>().book.addSearch(code);
                  Future.delayed(1.seconds,
                      () => Get.find<HtlibApi>().book.onSearchDone());
                },
                iconData: Feather.book_open,
                text: "Mã sách",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
