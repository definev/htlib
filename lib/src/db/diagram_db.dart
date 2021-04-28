import 'package:htlib/src/db/core/core_db.dart';
import 'package:htlib/src/db/core/crud_db.dart';
import 'package:htlib/src/model/diagram_node.dart';

class DiagramDb extends CoreDb<DiagramNode> implements CRUDDb<DiagramNode> {
  DiagramDb() : super("DiagramDb");

  List<DiagramNode> getList() {
    List<DiagramNode> _list = box?.values.toSet().toList() ?? [];
    _list.sort((e1, e2) => e1.id.compareTo(e2.id));
    return _list;
  }

  @override
  void add(DiagramNode data) => write(data.id, data);

  @override
  void addList(List<DiagramNode> dataList) =>
      dataList.forEach((data) => add(data));

  @override
  void edit(DiagramNode data) => write(data.id, data);

  @override
  DiagramNode? getDataById(String id) => read(id);

  @override
  void remove(DiagramNode data) => delete(data.id);

  List<String> sortedBookList() {
    List<String> res = [];
    getList().map((e) => res.addAll(e.bookList));
    return res;
  }

  void addBook(DiagramNode node, String book) {
    node = node.copyWith(bookList: [...node.bookList, book]);
    edit(node);
  }

  void addBookList(DiagramNode node, List<String> bookList) {
    node = node.copyWith(bookList: [...node.bookList, ...bookList]);
    edit(node);
  }

  void removeBook(DiagramNode node, String book) {
    List<String> _list = node.bookList;
    _list.remove(book);
    node = node.copyWith(bookList: _list);
    edit(node);
  }

  void removeBookList(DiagramNode node, List<String> bookList) {
    List<String> _list = node.bookList;
    bookList.forEach((book) => _list.remove(book));
    node = node.copyWith(bookList: _list);
    edit(node);
  }
}
