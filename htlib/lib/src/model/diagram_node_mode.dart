import 'package:hive/hive.dart';
import 'package:htlib/src/model/hive_id.dart';

part 'diagram_node_mode.g.dart';

enum PortalDirection { UP, LEFT, DOWN, RIGHT }
enum VertexRelation { CAN_ADD, CONNECT, HIDE }

@HiveType(typeId: HiveId.enum_diagram_mode)
enum DiagramNodeMode {
  @HiveField(0)
  OTHER,
  @HiveField(1)
  ENTRY,
  @HiveField(2)
  LIB,
  @HiveField(3)
  SHELVES,
}
