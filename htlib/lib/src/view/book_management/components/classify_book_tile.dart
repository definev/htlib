import 'package:flutter/material.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/view/book_management/components/book_list_tile.dart';

class ClassifyBookTile extends StatelessWidget {
  final String type;
  final List<Book> bookList;

  const ClassifyBookTile({Key key, this.type, this.bookList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(
            type,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        Expanded(
          child: ListView.builder(
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
  }
}
