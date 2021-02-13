import 'package:flutter/material.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/src/model/book_base.dart';
import 'package:htlib/styles.dart';

class BookBaseListTile extends StatelessWidget {
  final BookBase bookBase;
  final Function() onTap;

  const BookBaseListTile(this.bookBase, {Key key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        title: Text(bookBase.name),
        subtitle: Text(StringUtils.moneyFormat(bookBase.price, prefix: "VND")),
        isThreeLine: true,
        dense: true,
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
              Text(
                "SL:",
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
              Text(
                bookBase.quantity.toString(),
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
