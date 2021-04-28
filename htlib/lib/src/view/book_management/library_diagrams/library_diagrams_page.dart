import 'dart:math';

import 'package:flutter/material.dart';
import 'package:htlib/src/model/diagram_node.dart';
import 'package:htlib/src/model/diagram_node_mode.dart';
import 'package:htlib/src/services/state_management/diagram_node_notifier/diagram_node_notifier.dart';
import 'package:htlib/src/view/book_management/library_diagrams/components/diagram_end_drawer.dart';
import 'package:htlib/src/view/book_management/library_diagrams/components/diagram_title.dart';
import 'package:htlib/src/view/book_management/library_diagrams/model/library_config.dart';
import 'package:htlib/src/widget/htlib_bottom_bar.dart';
import 'package:htlib/styles.dart';
import 'package:provider/provider.dart';

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

  LibraryConfig get config => context.read();
  DiagramEndDrawerNotifier _nodeNotifier = DiagramEndDrawerNotifier();

  bool isInit = false;

  @override
  void initState() {
    super.initState();
    _nodeNotifier.changeNode(_service.anchor);
    _nodeNotifier.addListener(() {
      switch (_nodeNotifier.state) {
        case DiagramEndDrawerNotifierState.CHANGE:
          break;
        case DiagramEndDrawerNotifierState.EDIT_LABEL:
          _service.editNode(_nodeNotifier.node!);
          setState(() {});
          break;
        case DiagramEndDrawerNotifierState.EDIT_MODE:
          _service.editNode(_nodeNotifier.node!);
          setState(() {});
          break;
        case DiagramEndDrawerNotifierState.NO_STATE:
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isInit == false) {
      config.addListener(() {
        setState(() {});
      });
      isInit = true;
    }

    return ChangeNotifierProvider<DiagramEndDrawerNotifier>.value(
      value: _nodeNotifier,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Sơ đồ thư viện"),
          actions: [
            Container(),
            Builder(
              builder: (context) => Padding(
                padding: EdgeInsets.only(right: Insets.sm),
                child: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    _nodeNotifier.settings();
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
            ),
          ],
        ),
        endDrawerEnableOpenDragGesture: false,
        endDrawer: DiagramEndDrawer(),
        body: Stack(
          children: [
            InteractiveViewer(
              transformationController: _transformationController,
              constrained: false,
              boundaryMargin: EdgeInsets.all(double.infinity),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: max(
                      (MediaQuery.of(context).size.width - config.width) / 2,
                      0),
                  vertical: max(
                      (MediaQuery.of(context).size.height - config.height) / 2,
                      0),
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
                                _nodeNotifier.changeNode(node);
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
            Align(
              alignment: Alignment.bottomCenter,
              child: HtlibBottomBar(),
            ),
          ],
        ),
      ),
    );
  }
}
