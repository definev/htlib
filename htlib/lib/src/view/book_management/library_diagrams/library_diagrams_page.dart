import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/src/view/book_management/library_diagrams/components/diagram_endrawer.dart';
import 'package:htlib/src/view/book_management/library_diagrams/components/diagram_title.dart';
import 'package:htlib/src/view/book_management/library_diagrams/model/library_config.dart';

class LibraryDiagram extends StatefulWidget {
  @override
  _LibraryDiagramState createState() => _LibraryDiagramState();
}

class _LibraryDiagramState extends State<LibraryDiagram> {
  DiagramNodeService _service = DiagramNodeService([
    DiagramNode(
      "0",
      label: "Cổng vào",
      bookCatagories: [],
      mode: DiagramNodeMode.ENTRY,
    )
  ]);
  TransformationController _transformationController =
      TransformationController();

  LibraryConfig get config => Get.find<LibraryConfig>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Sơ đồ thư viện"),
        actions: [Container()],
      ),
      endDrawerEnableOpenDragGesture: false,
      endDrawer: DiagramEndDrawer(),
      body: InteractiveViewer(
        transformationController: _transformationController,
        constrained: false,
        boundaryMargin: EdgeInsets.all(double.infinity),
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
                    return SizedBox(width: config.width, height: config.height);
                  }
                  DiagramNode node = _service.matrix[index][nodeIndex]!;

                  return Builder(builder: (context) {
                    return DiagramTile(
                      upRelation: _service.canAddUp(node),
                      downRelation: _service.canAddDown(node),
                      leftRelation: _service.canAddLeft(node),
                      rightRelation: _service.canAddRight(node),
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      onAddNewDirection: (direction) {
                        _service.addNewNode(
                            node,
                            DiagramNode.newNode(
                                direction, node, _service.nextId),
                            direction);

                        setState(() {});
                      },
                      node: node,
                      onModeChange: (DiagramNodeMode newMode) {
                        _service.editNode(node.copyWith(mode: newMode));
                        setState(() {});
                      },
                    );
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
