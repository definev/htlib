import 'package:htlib/src/db/core/core_db.dart';
import 'package:htlib/src/model/diagram_node.dart';

class DiagramDb extends CoreDb<DiagramNode> {
  DiagramDb(String tableName) : super(tableName);

  void setNode(DiagramNode node) => write(node.id, node);
  DiagramNode getNode(String id) => read(id);
  void deleteNode(DiagramNode node) => delete(node.id);

  List<DiagramNode> getList() => box?.values.toList() ?? [];
}
