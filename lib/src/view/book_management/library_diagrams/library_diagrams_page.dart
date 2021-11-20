import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/src/model/admin_user.dart';
import 'package:htlib/src/model/diagram_node.dart';
import 'package:htlib/src/model/diagram_node_mode.dart';
import 'package:htlib/src/services/admin_service.dart';
import 'package:htlib/src/services/book/diagram_node_service.dart';
import 'package:htlib/src/services/state_management/diagram_notifier/diagram_end_drawer_notifier.dart';
import 'package:htlib/src/services/state_management/diagram_notifier/diagram_bottom_bar_notifier.dart';
import 'package:htlib/src/utils/painter/logo.dart';
import 'package:htlib/src/view/book_management/library_diagrams/components/diagram_end_drawer.dart';
import 'package:htlib/src/view/book_management/library_diagrams/components/diagram_title.dart';
import 'package:htlib/src/view/book_management/library_diagrams/model/library_config.dart';
import 'package:htlib/src/view/book_management/library_diagrams/components/htlib_bottom_bar.dart';
import 'package:htlib/styles.dart';
import 'package:provider/provider.dart';

class LibraryDiagram extends StatefulWidget {
  @override
  _LibraryDiagramState createState() => _LibraryDiagramState();
}

class _LibraryDiagramState extends State<LibraryDiagram> {
  DiagramNodeService _diagramNodeService = DiagramNodeService();
  TransformationController _transformationController = TransformationController();

  LibraryConfig get config => context.read();
  DiagramEndDrawerNotifier _nodeNotifier = DiagramEndDrawerNotifier();
  DiagramBottomBarNotifier _bottomBarNotifier = DiagramBottomBarNotifier();

  bool isInit = false;
  AdminService? adminService;
  @override
  void initState() {
    super.initState();
    _diagramNodeService.init().then((_) {
      _nodeNotifier.changeNode(_diagramNodeService.anchor);
      _nodeNotifier.addListener(() {
        switch (_nodeNotifier.state) {
          case DiagramEndDrawerNotifierState.CHANGE:
            break;
          case DiagramEndDrawerNotifierState.EDIT_LABEL:
            _diagramNodeService.editNode(_nodeNotifier.node!);
            setState(() {});
            break;
          case DiagramEndDrawerNotifierState.EDIT_MODE:
            _diagramNodeService.editNode(_nodeNotifier.node!);
            setState(() {});
            break;
          case DiagramEndDrawerNotifierState.NO_STATE:
            break;
          default:
        }
      });
      setState(() {});

      _bottomBarNotifier.setUnsortedBookList(_diagramNodeService.unsortedBookList);
      _bottomBarNotifier.addListener(() => setState(() {}));
    });
    try {
      adminService = Get.find<AdminService>();
    } catch (e) {}
  }

  Widget libraryMap() {
    return InteractiveViewer(
      transformationController: _transformationController,
      constrained: false,
      boundaryMargin: EdgeInsets.all(double.infinity),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: max((MediaQuery.of(context).size.width - config.width) / 2, 0),
          vertical: max((MediaQuery.of(context).size.height - config.height) / 2, 0),
        ),
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
                    return SizedBox(width: config.width, height: config.height);
                  }
                  DiagramNode node = _diagramNodeService.matrix[index][nodeIndex]!;

                  return Builder(builder: (context) {
                    return DiagramTile(
                      upRelation: _diagramNodeService.canAddUp(node),
                      downRelation: _diagramNodeService.canAddDown(node),
                      leftRelation: _diagramNodeService.canAddLeft(node),
                      rightRelation: _diagramNodeService.canAddRight(node),
                      onTap: () {
                        _nodeNotifier.changeNode(node);
                        Scaffold.of(context).openEndDrawer();
                      },
                      onDragSuccess: (id) {
                        _diagramNodeService.editNode(
                          node.copyWith(bookList: [...node.bookList, id]),
                        );
                        _bottomBarNotifier.setUnsortedBookList(_diagramNodeService.unsortedBookList);
                        setState(() {});
                      },
                      onAddNewDirection: (direction) {
                        _diagramNodeService.addNewNode(node, direction);
                        setState(() {});
                      },
                      node: node,
                      onModeChange: (DiagramNodeMode newMode) {
                        _diagramNodeService.editNode(node.copyWith(mode: newMode));
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

  @override
  Widget build(BuildContext context) {
    if (isInit == false) {
      config.addListener(() {
        setState(() {});
      });
      isInit = true;
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DiagramEndDrawerNotifier>.value(value: _nodeNotifier),
        ChangeNotifierProvider<DiagramBottomBarNotifier>.value(value: _bottomBarNotifier),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Sơ đồ thư viện",
            style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            if (adminService != null && adminService!.currentUser.value.adminType == AdminType.librarian)
              IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).colorScheme.onPrimary,
                tooltip: "Xóa nút mới nhất",
                onPressed: () {
                  bool success = _diagramNodeService.removeNode();
                  if (success) {
                    setState(() {});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Không thể xóa nút gốc"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            Builder(
              builder: (context) => Padding(
                padding: EdgeInsets.only(right: Insets.sm),
                child: IconButton(
                  color: Theme.of(context).colorScheme.onPrimary,
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
        body: (_diagramNodeService.isReady == false)
            ? Center(child: LogoIndicator())
            : Stack(
                children: [
                  libraryMap(),
                  if (adminService != null && adminService!.currentUser.value.adminType == AdminType.librarian)
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
