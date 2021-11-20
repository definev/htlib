import 'package:flutter/material.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/view/book_management/components/book_list_tile.dart';
import 'package:htlib/src/view/book_management/printing/book_list_printing_screen.dart';
import 'package:htlib/styles.dart';

class ClassifyBookPritingScreen extends StatefulWidget {
  final String? type;
  final List<Book>? bookList;

  const ClassifyBookPritingScreen({Key? key, this.type, this.bookList}) : super(key: key);

  @override
  _ClassifyBookPritingScreenState createState() => _ClassifyBookPritingScreenState();
}

class _ClassifyBookPritingScreenState extends State<ClassifyBookPritingScreen> {
  late List<bool> _checkedList;
  @override
  void initState() {
    super.initState();
    _checkedList = List.generate(
      widget.bookList!.length,
      (index) => false,
    );
  }

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
          widget.type!,
          style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(color: Theme.of(context).colorScheme.onSecondary),
        ),
        actions: [
          if (_checkedList.contains(true))
            Padding(
              padding: EdgeInsets.only(right: Insets.m),
              child: IconButton(
                icon: Icon(Icons.check, color: Theme.of(context).colorScheme.onSecondary),
                onPressed: () {
                  List<Book> bookList = [];
                  for (int i = 0; i < _checkedList.length; i++) {
                    if (_checkedList[i] == true) bookList.add(widget.bookList![i]);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookListPrintingScreen(
                        List.generate(
                          bookList.length,
                          (index) => bookList[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget.bookList!.length,
        itemBuilder: (context, index) {
          return BookListTile(
            widget.bookList![index],
            key: ValueKey("${widget.bookList![index].id}"),
            checkMode: CheckMode(
              _checkedList[index],
              onCheck: (check) => setState(() => _checkedList[index] = check!),
            ),
          );
        },
      ),
    );
  }
}
