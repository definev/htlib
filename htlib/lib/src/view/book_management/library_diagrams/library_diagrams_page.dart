import 'package:flutter/material.dart';
import 'package:htlib/src/view/book_management/library_diagrams/components/diagram_title.dart';
import 'package:htlib/styles.dart';

class LibraryDiagram extends StatefulWidget {
  @override
  _LibraryDiagramState createState() => _LibraryDiagramState();
}

class _LibraryDiagramState extends State<LibraryDiagram> {
  DiagramNodeService _diagramNodeService = DiagramNodeService([
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
            _diagramNodeService.matrix.length,
            (index) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _diagramNodeService.matrix[index].length,
                (nodeIndex) {
                  if (_diagramNodeService.matrix[index][nodeIndex] == null) {
                    return Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.all(Insets.sm),
                      color: Colors.black,
                    );
                  }
                  return DiagramTile(
                    onAddNewDirection: (direction) {
                      DiagramNode node =
                          _diagramNodeService.matrix[index][nodeIndex]!;
                      _diagramNodeService.editNode(
                          node,
                          DiagramNode.newNode(
                              direction, node, _diagramNodeService.nextId),
                          direction);

                      setState(() {});
                    },
                    node: _diagramNodeService.matrix[index][nodeIndex]!,
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
