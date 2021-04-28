part of 'user_management_screen.dart';

class UserManagement {}

class UserSearchDelegate extends SearchDelegate<User> {
  final UserService userService;

  UserSearchDelegate(this.userService)
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
      List<User> suggestions = userService.getList().sublist(
            0,
            userService.getList().length > 5 ? 4 : userService.getList().length,
          );

      if (suggestions.isEmpty) {
        return Container();
      } else {
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) => UserListTile(suggestions[index]),
        );
      }
    }

    List<User> results = userService.search(query);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => UserListTile(results[index]),
    );
  }
}
