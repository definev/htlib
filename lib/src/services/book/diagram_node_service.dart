import 'dart:math';
import 'dart:developer' as dev;

import 'package:dartz/dartz.dart' show Tuple2;
import 'package:get/get.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/model/diagram_node.dart';
import 'package:htlib/src/model/diagram_node_mode.dart';
import 'package:htlib/src/services/book_service.dart';

class DiagramNodeService {
  Future<void> init() async {
    _nodes = await api.diagram.getList();

    if (_nodes.isEmpty) {
      var _entry = DiagramNode(
        "0",
        label: "Cổng vào",
        bookList: [],
        mode: DiagramNodeMode.ENTRY,
      );
      _addNode(_entry);
    }
    _reset();

    List<String> sortedList = [];
    List<String> rawList = [];

    sortedList = await api.diagram.sortedBookList();
    rawList = bookService.bookListCubit.list.map<String>((e) => e.id!).toList();

    sortedList.forEach(
      (book) => rawList.removeWhere((id) => book == id),
    );
    _unsortedBookList = rawList;
  }

  String get nextId => "${int.parse(_nodes.last.id) + 1}";

  List<String> _unsortedBookList = [];
  List<String> get unsortedBookList => _unsortedBookList;

  List<DiagramNode> _nodes = [];
  bool get isReady => _nodes.isNotEmpty;
  DiagramNode get anchor => _nodes.first;

  List<List<DiagramNode?>> _matrix = [];
  List<List<DiagramNode?>> get matrix => _matrix;

  DiagramNode? findNode(String id) => _nodes.firstWhere((e) => e.id == id);

  HtlibDb db = Get.find();
  HtlibApi api = Get.find();
  BookService bookService = Get.find();

  bool isUpEnd(DiagramNode node) => node.down == null && node.left == null && node.right == null;
  bool isDownEnd(DiagramNode node) => node.up == null && node.left == null && node.right == null;
  bool isLeftEnd(DiagramNode node) => node.right == null && node.up == null && node.down == null;
  bool isRightEnd(DiagramNode node) => node.left == null && node.up == null && node.down == null;

  void _addNode(DiagramNode node) {
    _nodes.add(node);
    db.diagram.add(node);
    api.diagram.add(node);
  }

  void _editNode(DiagramNode node) {
    _nodes[_nodes.indexOf(node)] = node;
    db.diagram.edit(node);
    api.diagram.edit(node);
  }

  void _removeNode(DiagramNode node) {
    _nodes.remove(node);
    db.diagram.remove(node);
    api.diagram.remove(node);
  }

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
    if (node.up == _matrix[xy.value1 - 1][xy.value2]!.id) return VertexRelation.CONNECT;
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

    if (node.down == _matrix[xy.value1 + 1][xy.value2]!.id) return VertexRelation.CONNECT;
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
    if (node.left == _matrix[xy.value1][xy.value2 - 1]!.id) return VertexRelation.CONNECT;
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

    if (node.right == _matrix[xy.value1][xy.value2 + 1]!.id) return VertexRelation.CONNECT;
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

  void addNewNode(DiagramNode src, PortalDirection direction) {
    DiagramNode edge = DiagramNode.newNode(direction, src, nextId);
    src = src.copyWith(
      up: direction == PortalDirection.UP ? edge.id : null,
      down: direction == PortalDirection.DOWN ? edge.id : null,
      left: direction == PortalDirection.LEFT ? edge.id : null,
      right: direction == PortalDirection.RIGHT ? edge.id : null,
    );

    _addNode(edge);
    _editNode(src);
    _reset();
  }

  void editNode(DiagramNode node) {
    _editNode(node);
    node.bookList.forEach((id) {
      if (_unsortedBookList.contains(id)) {
        _unsortedBookList.remove(id);
      }
    });
    _reset();
  }

  bool removeNode() {
    if (_nodes.length == 1) {
      _nodes = [
        DiagramNode(
          "0",
          label: "Cổng vào",
          bookList: [],
          mode: DiagramNodeMode.ENTRY,
        )
      ];
      _reset();
      return false;
    }
    DiagramNode node = _nodes.last;
    String? up = node.up;
    String? down = node.down;
    String? left = node.left;
    String? right = node.right;
    late DiagramNode parentNode;
    if (up != null) {
      parentNode = findNode(up)!;
      parentNode = DiagramNode(
        parentNode.id,
        bookList: parentNode.bookList,
        label: parentNode.label,
        mode: parentNode.mode,
        up: parentNode.up,
        down: null,
        left: parentNode.left,
        right: parentNode.right,
      );
    }
    if (left != null) {
      parentNode = findNode(left)!;
      parentNode = DiagramNode(
        parentNode.id,
        bookList: parentNode.bookList,
        label: parentNode.label,
        mode: parentNode.mode,
        up: parentNode.up,
        down: parentNode.down,
        left: parentNode.left,
        right: null,
      );
    }
    if (down != null) {
      parentNode = findNode(down)!;
      parentNode = DiagramNode(
        parentNode.id,
        bookList: parentNode.bookList,
        label: parentNode.label,
        mode: parentNode.mode,
        up: null,
        down: parentNode.down,
        left: parentNode.left,
        right: parentNode.right,
      );
    }
    if (right != null) {
      parentNode = findNode(right)!;
      parentNode = DiagramNode(
        parentNode.id,
        bookList: parentNode.bookList,
        label: parentNode.label,
        mode: parentNode.mode,
        up: parentNode.up,
        down: parentNode.down,
        left: null,
        right: parentNode.right,
      );
    }

    _removeNode(node);
    _editNode(parentNode);

    if (node.bookList.isNotEmpty) {
      if (!_unsortedBookList.contains(node.id)) _unsortedBookList.add(node.id);
    }

    _reset();
    return true;
  }

  int get row {
    if (_nodes.isEmpty) return 0;
    int up = _upBFS(1, _nodes[0], PortalDirection.UP);
    int down = _downBFS(0, _nodes[0], PortalDirection.DOWN);
    return up + down + 1;
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
      maxDepth = max(_upBFS(depth + 1, findNode(node.up!)!, PortalDirection.UP), maxDepth);
    }
    if (node.left != null && direction != PortalDirection.RIGHT) {
      maxDepth = max(_upBFS(depth, findNode(node.left!)!, PortalDirection.LEFT), maxDepth);
    }
    if (node.right != null && direction != PortalDirection.LEFT) {
      maxDepth = max(_upBFS(depth, findNode(node.right!)!, PortalDirection.RIGHT), maxDepth);
    }

    return maxDepth;
  }

  int _downBFS(int depth, DiagramNode node, PortalDirection direction) {
    int maxDepth = depth;

    if (node.down != null) {
      maxDepth = max(_downBFS(depth + 1, findNode(node.down!)!, PortalDirection.UP), maxDepth);
    }
    if (node.left != null && direction != PortalDirection.RIGHT) {
      maxDepth = max(_downBFS(depth, findNode(node.left!)!, PortalDirection.LEFT), maxDepth);
    }
    if (node.right != null && direction != PortalDirection.LEFT) {
      maxDepth = max(_downBFS(depth, findNode(node.right!)!, PortalDirection.RIGHT), maxDepth);
    }

    return maxDepth;
  }

  int _leftBFS(int depth, DiagramNode node, PortalDirection direction) {
    int maxDepth = depth;

    if (node.left != null) {
      maxDepth = max(_leftBFS(depth + 1, findNode(node.left!)!, PortalDirection.LEFT), maxDepth);
    }
    if (node.up != null && direction != PortalDirection.DOWN) {
      maxDepth = max(_leftBFS(depth, findNode(node.up!)!, PortalDirection.UP), maxDepth);
    }
    if (node.down != null && direction != PortalDirection.UP) {
      maxDepth = max(_leftBFS(depth, findNode(node.down!)!, PortalDirection.DOWN), maxDepth);
    }

    return maxDepth;
  }

  int _rightBFS(int depth, DiagramNode node, PortalDirection direction) {
    int maxDepth = depth;

    if (node.right != null) {
      maxDepth = max(_rightBFS(depth + 1, findNode(node.right!)!, PortalDirection.RIGHT), maxDepth);
    }
    if (node.up != null && direction != PortalDirection.DOWN) {
      maxDepth = max(_rightBFS(depth, findNode(node.up!)!, PortalDirection.UP), maxDepth);
    }
    if (node.down != null && direction != PortalDirection.UP) {
      maxDepth = max(_rightBFS(depth, findNode(node.down!)!, PortalDirection.DOWN), maxDepth);
    }

    return maxDepth;
  }
}
