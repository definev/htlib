import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/src/model/user.dart';
import 'package:htlib/src/services/user_service.dart';
import 'package:htlib/src/view/user_management/components/user_grid_tile.dart';
import 'package:htlib/src/view/user_management/printing/user_printing_screen.dart';
import 'package:htlib/styles.dart';

class UserSelectPrintingScreen extends StatefulWidget {
  @override
  _UserSelectPrintingScreenState createState() =>
      _UserSelectPrintingScreenState();
}

class _UserSelectPrintingScreenState extends State<UserSelectPrintingScreen> {
  UserService userService = Get.find();

  List<User> _selected = [];

  int get tileNumber => (PageBreak.defaultPB.isMobile(context)
      ? 2
      : PageBreak.defaultPB.isTablet(context)
          ? 3
          : 4);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.print),
              onPressed: () {
                if (_selected.isEmpty) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Chưa chọn người nào!")));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UserPrintingScreen(_selected)));
                }
              },
            ),
            HSpace(Insets.sm),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: Insets.mid,
              right: Insets.mid,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VSpace(Insets.mid),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: Insets.mid),
                    child: Text(
                      "Chọn người in thẻ",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                Wrap(
                  // maxCrossAxisExtent: (MediaQuery.of(context).size.width - 2* Insets.mid) / (PageBreak.defaultPB.isMobile(context) ? 2 :PageBreak.defaultPB.isTablet(context) ? 3 : 4 ),
                  // mainAxisSpacing: Insets.sm,
                  // crossAxisSpacing: Insets.sm,
                  runSpacing: Insets.m,
                  spacing: Insets.m,
                  children: userService.getList().map<Widget>(
                    (e) {
                      return SizedBox(
                        height: PageBreak.defaultPB.isMobile(context)
                            ? MediaQuery.of(context).size.width
                            : (MediaQuery.of(context).size.width -
                                    2 * Insets.mid -
                                    (tileNumber - 1) * Insets.m) /
                                tileNumber,
                        width: PageBreak.defaultPB.isMobile(context)
                            ? MediaQuery.of(context).size.width
                            : (MediaQuery.of(context).size.width -
                                    2 * Insets.mid -
                                    (tileNumber - 1) * Insets.m) /
                                tileNumber,
                        child: UserGridTile(
                          e,
                          onTap: () {
                            if (_selected.contains(e)) {
                              _selected.remove(e);
                            } else {
                              _selected.add(e);
                            }
                            setState(() {});
                          },
                          selected: _selected.contains(e),
                        ),
                      );
                    },
                  ).toList(),
                ),
                VSpace(Insets.mid),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
