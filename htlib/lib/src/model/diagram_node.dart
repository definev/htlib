import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:htlib/src/model/diagram_node_mode.dart';
import 'package:htlib/src/model/hive_id.dart';

part 'diagram_node.g.dart';

@HiveType(typeId: HiveId.diagram_node)
class DiagramNode extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? up;
  @HiveField(2)
  final String? left;
  @HiveField(3)
  final String? down;
  @HiveField(4)
  final String? right;
  @HiveField(5)
  final String label;
  @HiveField(6)
  final List<String> bookList;
  @HiveField(7)
  final DiagramNodeMode mode;

  DiagramNode(
    this.id, {
    required this.label,
    required this.bookList,
    this.mode = DiagramNodeMode.UNCHOOSE,
    this.up,
    this.left,
    this.down,
    this.right,
  });

  static DiagramNode newNode(
          PortalDirection direction, DiagramNode node, String id) =>
      DiagramNode(
        id,
        label: "",
        bookList: [],
        down: direction == PortalDirection.UP ? node.id : null,
        up: direction == PortalDirection.DOWN ? node.id : null,
        left: direction == PortalDirection.RIGHT ? node.id : null,
        right: direction == PortalDirection.LEFT ? node.id : null,
      );

  DiagramNode copyWith(
          {String? label,
          String? up,
          String? left,
          String? down,
          String? right,
          DiagramNodeMode? mode,
          List<String>? bookList}) =>
      DiagramNode(
        id,
        label: label ?? this.label,
        bookList: bookList ?? this.bookList,
        up: up ?? this.up,
        left: left ?? this.left,
        down: down ?? this.down,
        right: right ?? this.right,
        mode: mode ?? this.mode,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "up": up,
        "left": left,
        "down": down,
        "right": right,
        "mode": mode.index,
        "bookList": bookList,
      };
  factory DiagramNode.fromJson(Map<String, dynamic> json) => DiagramNode(
        json["id"],
        label: json["label"],
        bookList: List.from(json["bookList"]),
        up: json["up"],
        left: json["left"],
        down: json["down"],
        right: json["right"],
        mode: DiagramNodeMode.values[json["mode"]],
      );

  @override
  List<Object?> get props => [id];
}
