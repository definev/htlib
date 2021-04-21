import 'dart:math';
import 'dart:developer' as dev;

import 'package:dartz/dartz.dart' show Tuple2;
import 'package:flutter/material.dart';

enum PortalDirection { UP, LEFT, DOWN, RIGHT }

typedef XYCordinate = Tuple2<int, int>;

class BookCatagory {}

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

  XYCordinate _getCordinate(DiagramNode node) {
    int _r = _upBFS(0, node, PortalDirection.UP);
    if (isDownEnd(node)) {
      _r = max(_upBFS(0, node, PortalDirection.UP),
          row - 1 - _downBFS(0, node, PortalDirection.DOWN));
    }
    int _l = _leftBFS(0, node, PortalDirection.LEFT);
    if (isRightEnd(node)) {
      _l = max(_leftBFS(0, node, PortalDirection.LEFT),
          col - 1 - _rightBFS(0, node, PortalDirection.RIGHT));
    }

    return Tuple2(_r, _l);
  }

  bool canAddUp(DiagramNode node) {
    XYCordinate xy = _getCordinate(node);
    if (xy.value1 == 0) return true;
    if (_matrix[xy.value1 - 1][xy.value2] != null) return false;
    return true;
  }

  bool canAddDown(DiagramNode node) {
    XYCordinate xy = _getCordinate(node);
    if (xy.value1 + 1 >= row) return true;
    if (_matrix[xy.value1 + 1][xy.value2] != null) return false;
    return true;
  }

  bool canAddLeft(DiagramNode node) {
    XYCordinate xy = _getCordinate(node);
    if (xy.value2 == 0) return true;
    if (_matrix[xy.value1][xy.value2 - 1] != null) return false;
    return true;
  }

  bool canAddRight(DiagramNode node) {
    XYCordinate xy = _getCordinate(node);
    if (xy.value2 + 1 >= col) return true;
    if (_matrix[xy.value1][xy.value2 + 1] != null) return false;
    return true;
  }

  void _reset() {
    _matrix = [];
    _matrix.addAll(
        List.generate(row, (index) => List.generate(col, (index) => null)));

    dev.log("ROW: ${_matrix.length} ------ COL: ${_matrix[0].length}");

    _nodes.forEach((node) {
      XYCordinate xy = _getCordinate(node);
      _matrix[xy.value1][xy.value2] = node;
    });
  }

  void editNode(DiagramNode src, DiagramNode edge, PortalDirection direction) {
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

class DiagramNode {
  final String id;
  final String? up;
  final String? left;
  final String? down;
  final String? right;
  final String label;
  final List<BookCatagory> bookCatagories;

  DiagramNode(
    this.id, {
    required this.label,
    required this.bookCatagories,
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
        bookCatagories: [],
        down: direction == PortalDirection.UP ? node.id : null,
        up: direction == PortalDirection.DOWN ? node.id : null,
        left: direction == PortalDirection.RIGHT ? node.id : null,
        right: direction == PortalDirection.LEFT ? node.id : null,
      );

  @override
  operator ==(Object o) {
    if (o is String) return o == this.id;
    if (o is DiagramNode) return o.id == this.id;
    return false;
  }

  DiagramNode copyWith(
          {String? label,
          String? up,
          String? left,
          String? down,
          String? right,
          List<BookCatagory>? bookCatagories}) =>
      DiagramNode(
        id,
        label: label ?? this.label,
        bookCatagories: bookCatagories ?? this.bookCatagories,
        up: up ?? this.up,
        left: left ?? this.left,
        down: down ?? this.down,
        right: right ?? this.right,
      );
}

class DiagramTile extends StatefulWidget {
  final bool enableAddUp;
  final bool enableAddDown;
  final bool enableAddLeft;
  final bool enableAddRight;

  final Function(PortalDirection direction) onAddNewDirection;
  final DiagramNode node;

  const DiagramTile({
    Key? key,
    required this.onAddNewDirection,
    required this.node,
    this.enableAddUp = true,
    this.enableAddDown = true,
    this.enableAddLeft = true,
    this.enableAddRight = true,
  }) : super(key: key);

  @override
  _DiagramTileState createState() => _DiagramTileState();
}

class _DiagramTileState extends State<DiagramTile> {
  double onEnd = 1.0;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          "ID: ${widget.node.id}\nUP: ${widget.node.up}\nDOWN: ${widget.node.down}\nLEFT: ${widget.node.left}\nRIGHT: ${widget.node.right}",
      child: Container(
        width: 150,
        height: 150,
        child: Column(
          children: [
            widget.node.up != null || !widget.enableAddUp
                ? Container(
                    height: 40,
                    width: 3,
                    color: Theme.of(context).primaryColor,
                  )
                : SizedBox(
                    height: 40,
                    width: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            widget.onAddNewDirection(PortalDirection.UP),
                        child: Icon(Icons.add, size: 18),
                      ),
                    ),
                  ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.node.left != null || !widget.enableAddLeft
                      ? SizedBox(
                          height: 40,
                          child: Center(
                            child: Container(
                              height: 3,
                              width: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 40,
                          width: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ElevatedButton(
                              onPressed: () => widget
                                  .onAddNewDirection(PortalDirection.LEFT),
                              child: Icon(Icons.add, size: 18),
                            ),
                          ),
                        ),
                  widget.node.right != null || !widget.enableAddRight
                      ? SizedBox(
                          height: 40,
                          child: Center(
                            child: Container(
                              height: 3,
                              width: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 40,
                          width: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ElevatedButton(
                              onPressed: () => widget
                                  .onAddNewDirection(PortalDirection.RIGHT),
                              child: Icon(Icons.add, size: 18),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            widget.node.down != null || !widget.enableAddDown
                ? Container(
                    height: 40,
                    width: 3,
                    color: Theme.of(context).primaryColor,
                  )
                : SizedBox(
                    height: 40,
                    width: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            widget.onAddNewDirection(PortalDirection.DOWN),
                        child: Icon(Icons.add, size: 18),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
