import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/view/book_management/components/book_list_tile.dart';
import 'package:htlib/src/view/book_management/components/classify_book/classify_book_more_info_screen.dart';
import 'package:htlib/styles.dart';

class ClassifyBookTile extends StatelessWidget {
  final String type;
  final List<Book> bookList;

  const ClassifyBookTile({Key key, this.type, this.bookList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      closedColor: Theme.of(context).backgroundColor,
      closedElevation: 0.0,
      openShape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      openColor: Theme.of(context).backgroundColor,
      openElevation: 0.0,
      closedBuilder: (context, onTap) {
        return Column(
          children: [
            AppBar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              title: Text(
                type,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Theme.of(context).colorScheme.onSecondary),
              ),
              leading: Icon(
                FontAwesome5Solid.book,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: Insets.sm),
                  child: IconButton(
                    icon: Icon(
                      Icons.more_horiz,
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
                itemCount: bookList.length,
                itemBuilder: (context, index) {
                  return BookListTile(
                    bookList[index],
                    key: ValueKey("$key: ${bookList[index].isbn}"),
                    enableEdited: true,
                  );
                },
              ),
            ),
          ],
        );
      },
      openBuilder: (context, onTap) {
        return ClassifyBookMoreInfoScreen(
          type: type,
          bookList: bookList,
        );
      },
      useRootNavigator: true,
    );
  }
}
