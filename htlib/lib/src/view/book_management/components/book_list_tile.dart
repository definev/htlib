import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/view/book_management/components/book_screen.dart';
import 'package:htlib/styles.dart';

class CountMode {
  final Function(int) add;
  final Function(int) remove;

  CountMode({this.add, this.remove});
}

class BookListTile extends StatelessWidget {
  final Book book;
  final Function() onTap;
  final CountMode countMode;
  final bool enableEdited;

  const BookListTile(this.book,
      {Key key, this.onTap, this.countMode, this.enableEdited = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget listTile = ListTile(
      tileColor: Theme.of(context).tileColor,
      onTap: onTap,
      title: Text(book.name, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        StringUtils.moneyFormat(book.price, subfix: "VND"),
        style: Theme.of(context).textTheme.bodyText2,
      ),
      isThreeLine: true,
      dense: PageBreak.defaultPB.isMobile(context) ? true : false,
      leading: Icon(Icons.menu_book),
      trailing: countMode != null
          ? SizedBox(
              height: 40,
              width: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => countMode.remove(book.quantity - 1),
                    child: Icon(Icons.remove, size: 18),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(40.0, 40.0)),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                  ),
                  Text("${book.quantity}",
                      style: Theme.of(context).textTheme.bodyText1),
                  ElevatedButton(
                    onPressed: () => countMode.add(book.quantity - 1),
                    child: Icon(Icons.add, size: 18),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(40.0, 40.0)),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: 40,
              width: 70,
              child: ElevatedButton(
                onPressed: () => onTap,
                child: Text("SL:${book.quantity}",
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )),
              ),
            ),
    );

    if (onTap != null) return listTile;

    return OpenContainer(
      closedShape: RoundedRectangleBorder(),
      closedColor: Theme.of(context).backgroundColor,
      openColor: Theme.of(context).backgroundColor,
      closedElevation: 2.0,
      openElevation: 2.0,
      openBuilder: (context, onTap) =>
          BookScreen(book, enableEdited: enableEdited),
      closedBuilder: (context, onTap) => listTile,
    );
  }
}
