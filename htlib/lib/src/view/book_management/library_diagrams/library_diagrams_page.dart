import 'package:flutter/material.dart';
import 'package:htlib/src/view/book_management/library_diagrams/components/diagram_title.dart';

class LibraryDiagram extends StatefulWidget {
  @override
  _LibraryDiagramState createState() => _LibraryDiagramState();
}

class _LibraryDiagramState extends State<LibraryDiagram> {
  DiagramNodeService _service = DiagramNodeService([
    DiagramNode("0", label: "TETETE", bookCatagories: []),
  ]);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sơ đồ thư viện")),
      body: InteractiveViewer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _service.matrix.length,
            (index) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _service.matrix[index].length,
                (nodeIndex) {
                  if (_service.matrix[index][nodeIndex] == null) {
                    return SizedBox(width: 150, height: 150);
                  }
                  DiagramNode node = _service.matrix[index][nodeIndex]!;

                  return DiagramTile(
                    enableAddUp: _service.canAddUp(node),
                    enableAddDown: _service.canAddDown(node),
                    enableAddLeft: _service.canAddLeft(node),
                    enableAddRight: _service.canAddRight(node),
                    onAddNewDirection: (direction) {
                      _service.editNode(
                          node,
                          DiagramNode.newNode(direction, node, _service.nextId),
                          direction);

                      setState(() {});
                    },
                    node: node,
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
