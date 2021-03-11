part of 'book_management_screen.dart';

class BookSearchDelegate extends SearchDelegate<Book> {
  final BookService bookService;

  BookSearchDelegate(this.bookService)
      : super(searchFieldLabel: "Tìm kiếm sách");

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Feather.arrow_left),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Dialog(child: Text("OK"));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      List<Book> suggestions = bookService.getList().sublist(
            0,
            bookService.getList().length > 5 ? 4 : bookService.getList().length,
          );

      if (suggestions.isEmpty) {
        return Container();
      } else {
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return OpenContainer(
              openElevation: 0.0,
              closedElevation: 0.0,
              openColor: Theme.of(context).tileColor,
              closedColor: Theme.of(context).tileColor,
              openBuilder: (context, action) => BookScreen(suggestions[index]),
              closedBuilder: (context, action) => BookListTile(
                suggestions[index],
                onTap: action,
              ),
            );
          },
        );
      }
    }

    List<Book> results = bookService.search(query);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return OpenContainer(
          openElevation: 0.0,
          closedElevation: 0.0,
          openColor: Theme.of(context).tileColor,
          closedColor: Theme.of(context).tileColor,
          openBuilder: (context, action) => BookScreen(results[index]),
          closedBuilder: (context, action) => BookListTile(
            results[index],
            onTap: action,
          ),
        );
      },
    );
  }
}
