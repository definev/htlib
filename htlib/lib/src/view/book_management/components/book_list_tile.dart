import 'package:flutter/material.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/styles.dart';

class BookListTile extends StatelessWidget {
  final Book book;
  final Function() onTap;
  final bool isSmall;

  const BookListTile(this.book, {Key key, this.onTap, this.isSmall = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).tileColor,
      onTap: () => onTap?.call(),
      title: Text(book.name, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        StringUtils.moneyFormat(book.price, subfix: "VND"),
        style: Theme.of(context).textTheme.bodyText2,
      ),
      isThreeLine: true,
      dense: PageBreak.defaultPB.isMobile(context) ? true : false,
      leading: Icon(Icons.menu_book),
      trailing: isSmall
          ? null
          : Container(
              height: 40,
              width: 65,
              child: ElevatedButton(
                onPressed: () => onTap?.call(),
                child: Text("SL:${book.quantity}",
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )),
              ),
            ),
    );
  }
}
