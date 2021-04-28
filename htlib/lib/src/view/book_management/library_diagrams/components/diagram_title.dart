import 'dart:math';
import 'dart:developer' as dev;

import 'package:dartz/dartz.dart' show Tuple2;
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/src/model/diagram_node.dart';
import 'package:htlib/src/model/diagram_node_mode.dart';
import 'package:htlib/src/view/book_management/library_diagrams/model/library_config.dart';
import 'package:htlib/styles.dart';

extension NodeExt on String {}

class DiagramNodeService {
  DiagramNodeService([List<DiagramNode>? init]) {
    if (init != null) {
      _nodes = init;
      _reset();
    }
  }

  String get nextId => "${int.parse(_nodes.last.id) + 1}";

  List<DiagramNode> _nodes = [];
  DiagramNode get anchor => _nodes.first;

  List<List<DiagramNode?>> _matrix = [];
  List<List<DiagramNode?>> get matrix => _matrix;

  DiagramNode? findNode(String id) => _nodes.firstWhere((e) => e == id);

  bool isUpEnd(DiagramNode node) =>
      node.down == null && node.left == null && node.right == null;
  bool isDownEnd(DiagramNode node) =>
      node.up == null && node.left == null && node.right == null;
  bool isLeftEnd(DiagramNode node) =>
      node.right == null && node.up == null && node.down == null;
  bool isRightEnd(DiagramNode node) =>
      node.left == null && node.up == null && node.down == null;

  Tuple2<int, int> _getCordinate(DiagramNode node) {
    int _r = _upBFS(0, node, PortalDirection.UP);
    if (isDownEnd(node)) {
      _r = max(
        _upBFS(0, node, PortalDirection.UP),
        row - 1 - _downBFS(0, node, PortalDirection.DOWN),
      );
    }
    int _l = _leftBFS(0, node, PortalDirection.LEFT);
    if (isRightEnd(node)) {
      _l = max(
        _leftBFS(0, node, PortalDirection.LEFT),
        col - 1 - _rightBFS(0, node, PortalDirection.RIGHT),
      );
    }

    return Tuple2(_r, _l);
  }

  VertexRelation canAddUp(DiagramNode node) {
    Tuple2<int, int> xy = _getCordinate(node);
    if (xy.value1 == 0) return VertexRelation.CAN_ADD;
    if (xy.value1 == 1) {
      if (node.up != null) return VertexRelation.CONNECT;
      if (_matrix[xy.value1 - 1][xy.value2] != null) return VertexRelation.HIDE;
      return VertexRelation.CAN_ADD;
    }
    if (_matrix[xy.value1 - 1][xy.value2] == null) {
      if (_matrix[xy.value1 - 2][xy.value2] != null) return VertexRelation.HIDE;
      return VertexRelation.CAN_ADD;
    }
    if (node.up == _matrix[xy.value1 - 1][xy.value2]!.id)
      return VertexRelation.CONNECT;
    return VertexRelation.HIDE;
  }

  VertexRelation canAddDown(DiagramNode node) {
    Tuple2<int, int> xy = _getCordinate(node);

    if (xy.value1 == row - 1) return VertexRelation.CAN_ADD;
    if (xy.value1 == row - 2) {
      if (node.down != null) return VertexRelation.CONNECT;
      if (_matrix[xy.value1 + 1][xy.value2] != null) return VertexRelation.HIDE;
      return VertexRelation.CAN_ADD;
    }

    if (_matrix[xy.value1 + 1][xy.value2] == null) {
      if (_matrix[xy.value1 + 2][xy.value2] != null) return VertexRelation.HIDE;
      return VertexRelation.CAN_ADD;
    }

    if (node.down == _matrix[xy.value1 + 1][xy.value2]!.id)
      return VertexRelation.CONNECT;
    return VertexRelation.HIDE;
  }

  VertexRelation canAddLeft(DiagramNode node) {
    Tuple2<int, int> xy = _getCordinate(node);
    if (xy.value2 == 0) return VertexRelation.CAN_ADD;
    if (xy.value2 == 1) {
      if (node.left != null) return VertexRelation.CONNECT;
      if (_matrix[xy.value1][xy.value2 - 1] != null) return VertexRelation.HIDE;
      return VertexRelation.CAN_ADD;
    }
    if (_matrix[xy.value1][xy.value2 - 1] == null) {
      if (_matrix[xy.value1][xy.value2 - 2] != null) return VertexRelation.HIDE;
      return VertexRelation.CAN_ADD;
    }
    if (node.left == _matrix[xy.value1][xy.value2 - 1]!.id)
      return VertexRelation.CONNECT;
    return VertexRelation.HIDE;
  }

  VertexRelation canAddRight(DiagramNode node) {
    Tuple2<int, int> xy = _getCordinate(node);

    if (xy.value2 == col - 1) return VertexRelation.CAN_ADD;
    if (xy.value2 == col - 2) {
      if (node.right != null) return VertexRelation.CONNECT;
      if (_matrix[xy.value1][xy.value2 + 1] != null) return VertexRelation.HIDE;
      return VertexRelation.CAN_ADD;
    }

    if (_matrix[xy.value1][xy.value2 + 1] == null) {
      if (_matrix[xy.value1][xy.value2 + 2] != null) return VertexRelation.HIDE;
      return VertexRelation.CAN_ADD;
    }

    if (node.right == _matrix[xy.value1][xy.value2 + 1]!.id)
      return VertexRelation.CONNECT;
    return VertexRelation.HIDE;
  }

  void _reset() {
    _matrix = [];
    _matrix.addAll(
      List.generate(
        row,
        (index) => List.generate(col, (index) => null),
      ),
    );

    dev.log("ROW: ${_matrix.length} ------ COL: ${_matrix[0].length}");

    _nodes.forEach((node) {
      Tuple2<int, int> xy = _getCordinate(node);
      dev.log(
          "NODE: ${node.id},\n|-- UP: ${node.up} - Distance: ${_upBFS(0, node, PortalDirection.UP)}\n|-- LEFT: ${node.left} - Distance: ${_leftBFS(0, node, PortalDirection.LEFT)}\n|-- DOWN: ${node.down} - Distance: ${_downBFS(0, node, PortalDirection.DOWN)}\n--- RIGHT: ${node.right} - Distance: ${_rightBFS(0, node, PortalDirection.RIGHT)}");
      _matrix[xy.value1][xy.value2] = node;
    });
  }

  void editNode(DiagramNode node) {
    _nodes[_nodes.indexOf(node)] = node;
    _reset();
  }

  void addNewNode(
      DiagramNode src, DiagramNode edge, PortalDirection direction) {
    src = src.copyWith(
      up: direction == PortalDirection.UP ? edge.id : null,
      down: direction == PortalDirection.DOWN ? edge.id : null,
      left: direction == PortalDirection.LEFT ? edge.id : null,
      right: direction == PortalDirection.RIGHT ? edge.id : null,
    );
    _nodes[_nodes.indexOf(src)] = src;
    _nodes.add(edge);
    _reset();
  }

  int get row {
    if (_nodes.isEmpty) return 0;
    int up = _upBFS(1, _nodes[0], PortalDirection.UP);
    int down = _downBFS(0, _nodes[0], PortalDirection.DOWN);
    return up + down;
  }

  int get col {
    if (_nodes.isEmpty) return 0;
    int left = _leftBFS(1, _nodes[0], PortalDirection.LEFT);
    int right = _rightBFS(0, _nodes[0], PortalDirection.RIGHT);
    return left + right;
  }

  int _upBFS(int depth, DiagramNode node, PortalDirection direction) {
    int maxDepth = depth;

    if (node.up != null) {
      maxDepth = max(
          _upBFS(depth + 1, findNode(node.up!)!, PortalDirection.UP), maxDepth);
    }
    if (node.left != null && direction != PortalDirection.RIGHT) {
      maxDepth = max(
          _upBFS(depth, findNode(node.left!)!, PortalDirection.LEFT), maxDepth);
    }
    if (node.right != null && direction != PortalDirection.LEFT) {
      maxDepth = max(
          _upBFS(depth, findNode(node.right!)!, PortalDirection.RIGHT),
          maxDepth);
    }

    return maxDepth;
  }

  int _downBFS(int depth, DiagramNode node, PortalDirection direction) {
    int maxDepth = depth;

    if (node.down != null) {
      maxDepth = max(
          _downBFS(depth + 1, findNode(node.down!)!, PortalDirection.UP),
          maxDepth);
    }
    if (node.left != null && direction != PortalDirection.RIGHT) {
      maxDepth = max(
          _downBFS(depth, findNode(node.left!)!, PortalDirection.LEFT),
          maxDepth);
    }
    if (node.right != null && direction != PortalDirection.LEFT) {
      maxDepth = max(
          _downBFS(depth, findNode(node.right!)!, PortalDirection.RIGHT),
          maxDepth);
    }

    return maxDepth;
  }

  int _leftBFS(int depth, DiagramNode node, PortalDirection direction) {
    int maxDepth = depth;

    if (node.left != null) {
      maxDepth = max(
          _leftBFS(depth + 1, findNode(node.left!)!, PortalDirection.LEFT),
          maxDepth);
    }
    if (node.up != null && direction != PortalDirection.DOWN) {
      maxDepth = max(
          _leftBFS(depth, findNode(node.up!)!, PortalDirection.UP), maxDepth);
    }
    if (node.down != null && direction != PortalDirection.UP) {
      maxDepth = max(
          _leftBFS(depth, findNode(node.down!)!, PortalDirection.DOWN),
          maxDepth);
    }

    return maxDepth;
  }

  int _rightBFS(int depth, DiagramNode node, PortalDirection direction) {
    int maxDepth = depth;

    if (node.right != null) {
      maxDepth = max(
          _rightBFS(depth + 1, findNode(node.right!)!, PortalDirection.RIGHT),
          maxDepth);
    }
    if (node.up != null && direction != PortalDirection.DOWN) {
      maxDepth = max(
          _rightBFS(depth, findNode(node.up!)!, PortalDirection.UP), maxDepth);
    }
    if (node.down != null && direction != PortalDirection.UP) {
      maxDepth = max(
          _rightBFS(depth, findNode(node.down!)!, PortalDirection.DOWN),
          maxDepth);
    }

    return maxDepth;
  }
}

class DiagramTile extends StatefulWidget {
  final VertexRelation upRelation;
  final VertexRelation downRelation;
  final VertexRelation leftRelation;
  final VertexRelation rightRelation;

  final DiagramNode node;
  final Function(DiagramNodeMode newMode) onModeChange;
  final Function(PortalDirection direction) onAddNewDirection;
  final Function() onTap;

  const DiagramTile({
    Key? key,
    required this.onAddNewDirection,
    required this.node,
    required this.onModeChange,
    required this.onTap,
    this.upRelation = VertexRelation.CAN_ADD,
    this.downRelation = VertexRelation.CAN_ADD,
    this.leftRelation = VertexRelation.CAN_ADD,
    this.rightRelation = VertexRelation.CAN_ADD,
  }) : super(key: key);

  @override
  _DiagramTileState createState() => _DiagramTileState();
}

class _DiagramTileState extends State<DiagramTile> {
  double onEnd = 1.0;

  bool onHover = false;

  LibraryConfig get config => context.read();

  Widget addIcon(PortalDirection direction) => SizedBox(
        height: config.size,
        width: config.size,
        child: ElevatedButton(
          onPressed: () => widget.onAddNewDirection(direction),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondary),
            foregroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onSecondary),
          ),
          child: Icon(Icons.add, size: 18),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: config.height,
      width: config.width,
      child: Column(
        children: [
          <Widget>[
            addIcon(PortalDirection.UP),
            Container(
              height: config.size,
              width: 3,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Container(
              height: config.size,
              width: 3,
              color: Colors.transparent,
            ),
          ][widget.upRelation.index],
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                <Widget>[
                  addIcon(PortalDirection.LEFT),
                  SizedBox(
                    height: config.size,
                    child: Center(
                      child: Container(
                        height: 3,
                        width: config.size,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  Container(
                    height: 3,
                    width: config.size,
                    color: Colors.transparent,
                  )
                ][widget.leftRelation.index],
                DragTarget<String>(
                  onWillAccept: (value) {
                    onHover = true;
                    setState(() {});
                    return false;
                  },
                  onLeave: (data) {
                    onHover = false;
                    setState(() {});
                  },
                  onAccept: (data) {
                    onHover = false;
                    setState(() {});
                  },
                  builder: (context, candidateData, rejectedData) => Container(
                    height: config.height - 2 * config.size,
                    width: config.width - 2 * config.size,
                    padding: EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          onHover ? Colors.amber : Colors.blue,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon([
                            Icons.edit_outlined,
                            Icons.home_filled,
                            MaterialCommunityIcons.library,
                            MaterialCommunityIcons.library_shelves,
                          ][widget.node.mode.index]),
                          VSpace(Insets.m),
                          Text(
                            "${widget.node.label == "" ? 'New ' + widget.node.id : widget.node.label}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      onPressed: () {
                        widget.onTap();
                      },
                    ),
                  ),
                ),
                <Widget>[
                  addIcon(PortalDirection.RIGHT),
                  SizedBox(
                    height: config.size,
                    child: Center(
                      child: Container(
                        height: 3,
                        width: config.size,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  Container(
                    height: 3,
                    width: config.size,
                    color: Colors.transparent,
                  )
                ][widget.rightRelation.index],
              ],
            ),
          ),
          <Widget>[
            addIcon(PortalDirection.DOWN),
            Container(
              height: config.size,
              width: 3,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Container(
              height: config.size,
              width: 3,
              color: Colors.transparent,
            ),
          ][widget.downRelation.index],
        ],
      ),
    );
  }
}
