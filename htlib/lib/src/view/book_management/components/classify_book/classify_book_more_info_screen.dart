import 'package:flutter/material.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/view/book_management/components/book_list_tile.dart';

class ClassifyBookMoreInfoScreen extends StatelessWidget {
  final String type;
  final List<Book> bookList;

  const ClassifyBookMoreInfoScreen({Key key, this.type, this.bookList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          type,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Theme.of(context).colorScheme.onSecondary),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: bookList.length,
        itemBuilder: (context, index) {
          return BookListTile(
            bookList[index],
            key: ValueKey("$key: ${bookList[index].isbn}"),
          );
        },
      ),
    );
  }
}
