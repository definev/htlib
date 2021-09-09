import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/view/book_management/components/book_list_tile.dart';
import 'package:htlib/src/view/book_management/components/classify_book/classify_book_more_info_screen.dart';
import 'package:htlib/styles.dart';

class ClassifyBookTile extends StatefulWidget {
  final String? type;
  final List<Book>? bookList;

  const ClassifyBookTile({Key? key, this.type, this.bookList}) : super(key: key);

  @override
  State<ClassifyBookTile> createState() => _ClassifyBookTileState();
}

class _ClassifyBookTileState extends State<ClassifyBookTile> {
  AdminService? adminService;

  @override
  void initState() {
    super.initState();
    try {
      adminService = Get.find<AdminService>();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      closedColor: Theme.of(context).backgroundColor,
      closedElevation: 0.0,
      openShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      openColor: Theme.of(context).backgroundColor,
      openElevation: 0.0,
      closedBuilder: (context, onTap) => Column(
        children: [
          AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            primary: false,
            title: Text(
              widget.type!,
              style: Theme.of(context)
                  .appBarTheme
                  .titleTextStyle!
                  .copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            leading: Icon(
              FontAwesome5Solid.book,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            actions: [
              if (adminService != null && adminService!.currentUser.value.adminType == AdminType.librarian)
                Padding(
                  padding: EdgeInsets.only(right: Insets.sm),
                  child: IconButton(
                    icon: Icon(
                      Icons.print,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    onPressed: onTap,
                  ),
                ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.bookList!.length,
              itemBuilder: (context, index) {
                return BookListTile(
                  widget.bookList![index],
                  key: ValueKey("${widget.bookList![index].isbn}"),
                  enableEdited: true,
                );
              },
            ),
          ),
        ],
      ),
      openBuilder: (context, onTap) => ClassifyBookPritingScreen(
        type: widget.type,
        bookList: widget.bookList,
      ),
      useRootNavigator: true,
    );
  }
}
