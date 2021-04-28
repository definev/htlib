import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/src/model/diagram_node.dart';
import 'package:htlib/src/model/diagram_node_mode.dart';
import 'package:htlib/src/view/book_management/library_diagrams/model/library_config.dart';
import 'package:htlib/styles.dart';

class DiagramTile extends StatefulWidget {
  final VertexRelation upRelation;
  final VertexRelation downRelation;
  final VertexRelation leftRelation;
  final VertexRelation rightRelation;

  final DiagramNode node;
  final Function(DiagramNodeMode newMode) onModeChange;
  final Function(PortalDirection direction) onAddNewDirection;
  final Function() onTap;
  final Function(String id) onDragSuccess;

  const DiagramTile({
    Key? key,
    required this.onAddNewDirection,
    required this.node,
    required this.onModeChange,
    required this.onTap,
    required this.onDragSuccess,
    this.upRelation = VertexRelation.CAN_ADD,
    this.downRelation = VertexRelation.CAN_ADD,
    this.leftRelation = VertexRelation.CAN_ADD,
    this.rightRelation = VertexRelation.CAN_ADD,
  }) : super(key: key);

  @override
  _DiagramTileState createState() => _DiagramTileState();
}

class _DiagramTileState extends State<DiagramTile> {
  double onEnd = 1.0;

  bool onHover = false;

  LibraryConfig get config => context.read();

  Widget addIcon(PortalDirection direction) => SizedBox(
        height: config.size,
        width: config.size,
        child: ElevatedButton(
          onPressed: () => widget.onAddNewDirection(direction),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondary),
            foregroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onSecondary),
          ),
          child: Icon(Icons.add, size: 18),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: config.height,
      width: config.width,
      child: Column(
        children: [
          <Widget>[
            addIcon(PortalDirection.UP),
            Container(
              height: config.size,
              width: 3,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Container(
              height: config.size,
              width: 3,
              color: Colors.transparent,
            ),
          ][widget.upRelation.index],
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                <Widget>[
                  addIcon(PortalDirection.LEFT),
                  SizedBox(
                    height: config.size,
                    child: Center(
                      child: Container(
                        height: 3,
                        width: config.size,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  Container(
                    height: 3,
                    width: config.size,
                    color: Colors.transparent,
                  )
                ][widget.leftRelation.index],
                widget.node.mode == DiagramNodeMode.ENTRY
                    ? Container(
                        height: config.height - 2 * config.size,
                        width: config.width - 2 * config.size,
                        padding: EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              onHover
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.9),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                [
                                  Icons.meeting_room,
                                  Icons.home_filled,
                                  MaterialCommunityIcons.library,
                                  MaterialCommunityIcons.library_shelves,
                                ][widget.node.mode.index],
                              ),
                              VSpace(Insets.m),
                              Text(
                                "${widget.node.label == "" ? 'Phòng số ' + widget.node.id : widget.node.label}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          onPressed: () {
                            widget.onTap();
                          },
                        ),
                      )
                    : DragTarget<String>(
                        onWillAccept: (data) {
                          onHover = true;
                          setState(() {});
                          return true;
                        },
                        onLeave: (data) {
                          onHover = false;
                          setState(() {});
                        },
                        onAccept: (data) {
                          log(data);
                          onHover = false;
                          widget.onDragSuccess(data);
                          setState(() {});
                        },
                        builder: (context, candidateData, rejectedData) =>
                            Container(
                          height: config.height - 2 * config.size,
                          width: config.width - 2 * config.size,
                          padding: EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(onHover
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.8)
                                  : Theme.of(context).primaryColor),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  [
                                    Icons.meeting_room,
                                    Icons.home_filled,
                                    MaterialCommunityIcons.library,
                                    MaterialCommunityIcons.library_shelves,
                                  ][widget.node.mode.index],
                                ),
                                VSpace(Insets.m),
                                Text(
                                  "${widget.node.label == "" ? 'Phòng số ' + widget.node.id : widget.node.label}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            onPressed: () => widget.onTap(),
                          ),
                        ),
                      ),
                <Widget>[
                  addIcon(PortalDirection.RIGHT),
                  SizedBox(
                    height: config.size,
                    child: Center(
                      child: Container(
                        height: 3,
                        width: config.size,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  Container(
                    height: 3,
                    width: config.size,
                    color: Colors.transparent,
                  )
                ][widget.rightRelation.index],
              ],
            ),
          ),
          <Widget>[
            addIcon(PortalDirection.DOWN),
            Container(
              height: config.size,
              width: 3,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Container(
              height: config.size,
              width: 3,
              color: Colors.transparent,
            ),
          ][widget.downRelation.index],
        ],
      ),
    );
  }
}
