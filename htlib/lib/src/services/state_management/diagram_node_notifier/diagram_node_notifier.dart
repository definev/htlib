import 'package:flutter/material.dart';
import 'package:htlib/src/model/diagram_node.dart';
import 'package:htlib/src/model/diagram_node_mode.dart';

enum DiagramEndDrawerNotifierState {
  CHANGE,
  EDIT_LABEL,
  EDIT_MODE,
  NO_STATE,
  SETTINGS,
}

class DiagramEndDrawerNotifier extends ChangeNotifier {
  DiagramNode? node;
  DiagramEndDrawerNotifierState state = DiagramEndDrawerNotifierState.NO_STATE;

  void settings() {
    state = DiagramEndDrawerNotifierState.SETTINGS;
    notifyListeners();
  }

  void changeNode(DiagramNode newNode) {
    node = newNode;
    state = DiagramEndDrawerNotifierState.CHANGE;
    notifyListeners();
  }

  void changeLabel(String label) {
    node = node?.copyWith(label: label);
    state = DiagramEndDrawerNotifierState.EDIT_LABEL;
    notifyListeners();
  }

  void changeMode(DiagramNodeMode mode) {
    node = node?.copyWith(mode: mode);
    state = DiagramEndDrawerNotifierState.EDIT_MODE;
    notifyListeners();
  }
}
