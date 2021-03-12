import 'package:flutter/material.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/book.dart';
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

  const BookListTile(this.book, {Key key, this.onTap, this.countMode})
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
      trailing: countMode != null
          ? SizedBox(
              height: 40,
              width: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => countMode.remove(book.quantity - 1),
                    child: Icon(Icons.remove, size: 18),
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(45.0, 45.0))),
                  ),
                  Text("${book.quantity}",
                      style: Theme.of(context).textTheme.bodyText1),
                  ElevatedButton(
                    onPressed: () => countMode.add(book.quantity - 1),
                    child: Icon(Icons.add, size: 18),
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(45.0, 45.0))),
                  ),
                ],
              ),
            )
          : Container(
              height: 40,
              width: 70,
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
