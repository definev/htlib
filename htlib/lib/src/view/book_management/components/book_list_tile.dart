import 'package:flutter/material.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/book_base.dart';
import 'package:htlib/styles.dart';

class BookListTile extends StatelessWidget {
  final Book book;
  final Function() onTap;

  const BookListTile(this.book, {Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: Theme.of(context).tileColor,
          onTap: onTap,
          title: Text(book.name, overflow: TextOverflow.ellipsis),
          subtitle: Text(StringUtils.moneyFormat(book.price, subfix: "VND")),
          isThreeLine: true,
          dense: PageBreak.defaultPB.isMobile(context) ? true : false,
          leading: Icon(Icons.menu_book),
          trailing: Container(
            decoration: BoxDecoration(
              borderRadius: Corners.s5Border,
              color: Theme.of(context).primaryColor,
            ),
            height: 40,
            width: 65,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("SL:",
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )),
                Text(book.quantity.toString(),
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
