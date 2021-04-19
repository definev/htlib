import 'dart:math';

import 'package:flutter/material.dart';
import 'package:htlib/styles.dart';
import 'package:uuid/uuid.dart';

enum PortalDirection { UP, LEFT, DOWN, RIGHT }

class BookCatagory {}

class DiagramNode {
  final DiagramNode? up;
  final DiagramNode? left;
  final DiagramNode? down;
  final DiagramNode? right;
  final String label;
  final List<BookCatagory> bookCatagories;

  DiagramNode(
    this.label, {
    required this.bookCatagories,
    this.up,
    this.left,
    this.down,
    this.right,
  });

  static DiagramNode newNode(PortalDirection direction, DiagramNode node) =>
      DiagramNode(
        "${Uuid().v1()}",
        bookCatagories: [],
        down: direction == PortalDirection.UP ? node : null,
        up: direction == PortalDirection.DOWN ? node : null,
        left: direction == PortalDirection.RIGHT ? node : null,
        right: direction == PortalDirection.LEFT ? node : null,
      );

  int get height => max(leftHeight, rightHeight);
  int get width => max(upWidth, downWidth);

  int get upWidth {
    if (up != null) {
      DiagramNode _node = up!;
      int _leftDepth = _node.left == null ? 0 : _node.left!.upWidth;
      int _rightDepth = _node.right == null ? 0 : _node.right!.upWidth;
      return _leftDepth + _rightDepth + 1;
    } else {
      return (left != null ? 1 : 0) + (right != null ? 1 : 0) + 1;
    }
  }

  int get downWidth {
    if (down != null) {
      DiagramNode _node = down!;
      int _leftDepth = _node.left == null ? 0 : _node.left!.downWidth;
      int _rightDepth = _node.right == null ? 0 : _node.right!.downWidth;
      return _leftDepth + _rightDepth + 1;
    } else {
      return (left != null ? 1 : 0) + (right != null ? 1 : 0) + 1;
    }
  }

  int get leftHeight {
    if (left != null) {
      DiagramNode _node = left!;
      int _upDepth = _node.up == null ? 0 : _node.up!.leftHeight;
      int _downDepth = _node.down == null ? 0 : _node.down!.leftHeight;
      return _upDepth + _downDepth + 1;
    } else {
      return (up != null ? 1 : 0) + (down != null ? 1 : 0) + 1;
    }
  }

  int get rightHeight {
    if (right != null) {
      DiagramNode _node = right!;
      int _upDepth = _node.up == null ? 0 : _node.up!.rightHeight;
      int _downDepth = _node.down == null ? 0 : _node.down!.rightHeight;
      return _upDepth + _downDepth + 1;
    } else {
      return (up != null ? 1 : 0) + (down != null ? 1 : 0) + 1;
    }
  }

  @override
  operator ==(Object o) {
    if (o is DiagramNode) return o.label == this.label;
    return false;
  }

  DiagramNode copyWith(
          {String? label,
          DiagramNode? up,
          DiagramNode? left,
          DiagramNode? down,
          DiagramNode? right,
          List<BookCatagory>? bookCatagories}) =>
      DiagramNode(
        label ?? this.label,
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
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.node.up == null
              ? IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () => widget.onAddNewDirection(PortalDirection.UP),
                )
              : Container(
                  height: 20,
                  width: 2,
                  color: Colors.black,
                ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () => widget.onAddNewDirection(PortalDirection.LEFT),
              ),
              Container(
                decoration: BoxDecoration(border: Border.all(width: 2)),
                padding: EdgeInsets.all(Insets.m),
                child: Text("Cổng thư viện",
                    style: Theme.of(context).textTheme.subtitle2),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () =>
                    widget.onAddNewDirection(PortalDirection.RIGHT),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () => widget.onAddNewDirection(PortalDirection.DOWN),
          ),
        ],
      ),
    );
  }
}
