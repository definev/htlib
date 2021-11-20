import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/utils.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/model/renting_history.dart';
import 'package:htlib/src/services/renting_history_service.dart';
import 'package:htlib/src/view/renting_history_management/components/renting_history_screen.dart';
import 'package:htlib/styles.dart';

class ScannerScreen extends StatelessWidget {
  Widget button(BuildContext context,
      {Function()? onPressed, IconData? iconData, required String text}) {
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
            VSpace(Insets.mid),
            Text(
              text,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
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
        Get.find<HtlibApi>().student.onSearchDone();
        Get.find<HtlibApi>().book.onSearchDone();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Quét mã",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                button(
                  context,
                  onPressed: () async {
                    String? code = await Utils.scanQrcode(context);
                    if (code != null) {
                      await Get.find<HtlibApi>().student.addSearch(code);
                    }
                  },
                  iconData: Feather.user,
                  text: "Mã người mượn",
                ),
                button(
                  context,
                  onPressed: () async {
                    String? code = await Utils.scanISBNCode(context);
                    if (code != null) {
                      await Get.find<HtlibApi>().book.addSearch(code);
                    }
                  },
                  iconData: Feather.book_open,
                  text: "Mã sách",
                ),
              ],
            ),
            SizedBox(height: 16),
            button(
              context,
              onPressed: () async {
                String? code = await Utils.scanQrcode(context);
                if (code != null) {
                  RentingHistory rentingHistory =
                      Get.find<RentingHistoryService>().getDataById(code);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RentingHistoryScreen(
                          stateCode: RentingHistoryStateCode
                              .values[rentingHistory.state],
                          rentingHistory: rentingHistory,
                          enableEdited: true,
                        ),
                      ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Không tìm thấy lịch sử mượn")));
                }
              },
              iconData: Feather.file_text,
              text: "Lịch sử mượn",
            ),
          ],
        ),
      ),
    );
  }
}
