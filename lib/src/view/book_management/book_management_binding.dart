part of 'book_management_screen.dart';

class BookSearchDelegate extends SearchDelegate<Book> {
  final BookService? bookService;

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
      List<Book> suggestions = bookService!.getList().sublist(
            0,
            bookService!.getList().length > 5 ? 4 : bookService!.getList().length,
          );

      if (suggestions.isEmpty) {
        return Container();
      } else {
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) => BookListTile(suggestions[index]),
        );
      }
    }

    List<Book> results = bookService!.search(query);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => BookListTile(results[index]),
    );
  }
}
