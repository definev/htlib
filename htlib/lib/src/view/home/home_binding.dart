part of 'home_screen.dart';

class BookSearchDelegate extends SearchDelegate<BookBase> {
  final BookService bookService;

  BookSearchDelegate(this.bookService);

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
    return Dialog(
      child: Text("OK"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      List<BookBase> suggestions = bookService.list.sublist(
        0,
        bookService.list.length > 5 ? 4 : bookService.list.length,
      );

      if (suggestions.isEmpty) {
        return Container();
      } else {
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return BookBaseListTile(
              suggestions[index],
              onTap: () => close(context, suggestions[index]),
            );
          },
        );
      }
    }

    List<BookBase> results = bookService.search(query);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return BookBaseListTile(
          results[index],
          onTap: () => close(context, results[index]),
        );
      },
    );
  }
}
