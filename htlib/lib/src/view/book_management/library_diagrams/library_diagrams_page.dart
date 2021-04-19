import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:htlib/src/view/book_management/library_diagrams/components/diagram_title.dart';

class LibraryDiagram extends StatefulWidget {
  @override
  _LibraryDiagramState createState() => _LibraryDiagramState();
}

class _LibraryDiagramState extends State<LibraryDiagram> {
  List<DiagramNode> nodes = [
    DiagramNode(
      "Chào mọi người",
      bookCatagories: [],
    ),
  ];
  List<List<DiagramNode?>> nodeMatrix = [];

  void resetMatrix() {
    if (nodes.isNotEmpty) {
      log("MAP: ${nodes[0].width} * ${nodes[0].height}");
      nodeMatrix.addAll(
        List.generate(
          nodes[0].height,
          (index) => List.generate(
            nodes[0].width,
            (_) => null,
          ),
        ),
      );

      nodes.forEach((node) {
        log("ADD NODE: ${node.upWidth - 1} * ${node.leftHeight - 1}");
        nodeMatrix[node.upWidth - 1][node.leftHeight - 1] = node;
      });
      log("MAP: ${nodeMatrix.length} * ${nodeMatrix[0].length}");
    }
  }

  @override
  void initState() {
    super.initState();
    resetMatrix();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sơ đồ thư viện")),
      body: InteractiveViewer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            nodeMatrix.length,
            (index) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                nodeMatrix[index].length,
                (nodeIndex) {
                  if (nodeMatrix[index][nodeIndex] == null) {
                    return Container(height: 50, width: 150);
                  }
                  return DiagramTile(
                    onAddNewDirection: (direction) {
                      DiagramNode node = nodeMatrix[index][nodeIndex]!;
                      DiagramNode _newNode =
                          DiagramNode.newNode(direction, node);

                      switch (direction) {
                        case PortalDirection.UP:
                          node = node.copyWith(up: _newNode);
                          nodes[nodes.indexOf(node)] = node;
                          nodes.add(_newNode);
                          break;
                        case PortalDirection.DOWN:
                          node = node.copyWith(down: _newNode);
                          nodes[nodes.indexOf(node)] = node;
                          nodes.add(_newNode);
                          break;
                        case PortalDirection.LEFT:
                          node = node.copyWith(left: _newNode);
                          nodes[nodes.indexOf(node)] = node;
                          nodes.add(_newNode);
                          break;
                        case PortalDirection.RIGHT:
                          node = node.copyWith(right: _newNode);
                          nodes[nodes.indexOf(node)] = node;
                          nodes.add(_newNode);
                          break;
                        default:
                      }
                      setState(() => resetMatrix());
                    },
                    node: nodeMatrix[index][nodeIndex]!,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
