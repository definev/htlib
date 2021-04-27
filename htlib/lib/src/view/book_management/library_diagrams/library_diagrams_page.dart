import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/src/model/diagram_node.dart';
import 'package:htlib/src/model/diagram_node_mode.dart';
import 'package:htlib/src/services/state_management/diagram_node_config/diagram_node_config_cubit.dart';
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
      bookList: [],
      mode: DiagramNodeMode.ENTRY,
    )
  ]);
  TransformationController _transformationController =
      TransformationController();

  late DiagramNodeConfigCubit _cubit;

  LibraryConfig get config => Get.find<LibraryConfig>();

  @override
  void initState() {
    super.initState();
    _cubit = DiagramNodeConfigCubit(_service.anchor);
    Get.put(_cubit);
  }

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
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                max((MediaQuery.of(context).size.width - config.width) / 2, 0),
            vertical: max(
                (MediaQuery.of(context).size.height - config.height) / 2, 0),
          ),
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
                      return SizedBox(
                          width: config.width, height: config.height);
                    }
                    DiagramNode node = _service.matrix[index][nodeIndex]!;

                    return Builder(builder: (context) {
                      return DiagramTile(
                        upRelation: _service.canAddUp(node),
                        downRelation: _service.canAddDown(node),
                        leftRelation: _service.canAddLeft(node),
                        rightRelation: _service.canAddRight(node),
                        onTap: () {
                          var _cubit = DiagramNodeConfigCubit(node);
                          _cubit.stream.listen((event) => setState(() {
                                event.map(
                                  initial: (_) {},
                                  done: (newNode) =>
                                      _service.editNode(newNode.node),
                                );
                              }));
                          Get.put(_cubit);
                          Scaffold.of(context).openEndDrawer();
                        },
                        onAddNewDirection: (direction) {
                          _service.addNewNode(
                            node,
                            DiagramNode.newNode(
                                direction, node, _service.nextId),
                            direction,
                          );

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
      ),
    );
  }
}
