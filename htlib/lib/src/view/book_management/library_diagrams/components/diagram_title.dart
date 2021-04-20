import 'dart:math';

import 'package:flutter/material.dart';
import 'package:htlib/styles.dart';

enum PortalDirection { UP, LEFT, DOWN, RIGHT }

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

  void _reset() {
    _matrix = [];
    _matrix.addAll(
      List.generate(row, (index) => List.generate(col, (index) => null)),
    );

    _nodes.forEach((node) {
      int _r = _upBFS(0, node, PortalDirection.DOWN);
      int _l = _leftBFS(0, node, PortalDirection.RIGHT);
      _matrix[_r][_l] = node;
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
    int up = _upBFS(1, _nodes[0], PortalDirection.DOWN);
    int down = _downBFS(0, _nodes[0], PortalDirection.UP);
    return up + down;
  }

  int get col {
    if (_nodes.isEmpty) return 0;
    int left = _leftBFS(1, _nodes[0], PortalDirection.RIGHT);
    int right = _rightBFS(0, _nodes[0], PortalDirection.LEFT);
    return left + right;
  }

  bool isUpEnd(DiagramNode node) =>
      node.up == null && node.left == null && node.right == null;
  bool isDownEnd(DiagramNode node) =>
      node.down == null && node.left == null && node.right == null;
  bool isLeftEnd(DiagramNode node) =>
      node.up == null && node.down == null && node.right == null;
  bool isRightEnd(DiagramNode node) =>
      node.up == null && node.down == null && node.left == null;

  int _upBFS(int depth, DiagramNode node, PortalDirection direction) {
    if (isUpEnd(node)) return depth;
    if (isLeftEnd(node)) return depth;
    if (isRightEnd(node)) return depth;

    int maxDepth = depth;

    if (node.up != null) {
      maxDepth = max(
          _upBFS(depth + 1, findNode(node.up!)!, PortalDirection.DOWN),
          maxDepth);
    }
    if (node.left != null && direction != PortalDirection.RIGHT) {
      maxDepth = max(
          _upBFS(depth, findNode(node.left!)!, PortalDirection.RIGHT),
          maxDepth);
    }
    if (node.right != null && direction != PortalDirection.LEFT) {
      maxDepth = max(
          _upBFS(depth, findNode(node.right!)!, PortalDirection.LEFT),
          maxDepth);
    }

    return maxDepth;
  }

  int _downBFS(int depth, DiagramNode node, PortalDirection direction) {
    if (isDownEnd(node)) return depth;
    if (isLeftEnd(node)) return depth;
    if (isRightEnd(node)) return depth;

    int maxDepth = depth;

    if (node.down != null) {
      maxDepth = max(
          _downBFS(depth + 1, findNode(node.down!)!, PortalDirection.UP),
          maxDepth);
    }
    if (node.left != null && direction != PortalDirection.RIGHT) {
      maxDepth = max(
          _downBFS(depth, findNode(node.left!)!, PortalDirection.RIGHT),
          maxDepth);
    }
    if (node.right != null && direction != PortalDirection.LEFT) {
      maxDepth = max(
          _downBFS(depth, findNode(node.right!)!, PortalDirection.LEFT),
          maxDepth);
    }

    return maxDepth;
  }

  int _leftBFS(int depth, DiagramNode node, PortalDirection direction) {
    if (isRightEnd(node)) return depth;
    if (isDownEnd(node)) return depth;
    if (isUpEnd(node)) return depth;

    int maxDepth = depth;

    if (node.left != null) {
      maxDepth = max(
          _leftBFS(depth + 1, findNode(node.left!)!, PortalDirection.RIGHT),
          maxDepth);
    }
    if (node.up != null && direction != PortalDirection.DOWN) {
      maxDepth = max(
          _leftBFS(depth, findNode(node.up!)!, PortalDirection.DOWN), maxDepth);
    }
    if (node.down != null && direction != PortalDirection.UP) {
      maxDepth = max(
          _leftBFS(depth, findNode(node.down!)!, PortalDirection.UP), maxDepth);
    }

    return maxDepth;
  }

  int _rightBFS(int depth, DiagramNode node, PortalDirection direction) {
    if (isLeftEnd(node)) return depth;
    if (isDownEnd(node)) return depth;
    if (isUpEnd(node)) return depth;

    int maxDepth = depth;

    if (node.right != null) {
      maxDepth = max(
          _rightBFS(depth + 1, findNode(node.right!)!, PortalDirection.LEFT),
          maxDepth);
    }
    if (node.up != null && direction != PortalDirection.DOWN) {
      maxDepth = max(
          _rightBFS(depth, findNode(node.up!)!, PortalDirection.DOWN),
          maxDepth);
    }
    if (node.down != null && direction != PortalDirection.UP) {
      maxDepth = max(
          _rightBFS(depth, findNode(node.down!)!, PortalDirection.UP),
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
  final Function(PortalDirection direction) onAddNewDirection;
  final DiagramNode node;

  const DiagramTile(
      {Key? key, required this.onAddNewDirection, required this.node})
      : super(key: key);

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
        width: 100,
        height: 100,
        margin: EdgeInsets.all(Insets.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () => widget.onAddNewDirection(PortalDirection.UP),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () =>
                      widget.onAddNewDirection(PortalDirection.DOWN),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: () =>
                      widget.onAddNewDirection(PortalDirection.LEFT),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: () =>
                      widget.onAddNewDirection(PortalDirection.RIGHT),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
