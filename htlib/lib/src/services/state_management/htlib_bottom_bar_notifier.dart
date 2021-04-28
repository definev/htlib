import 'package:flutter/material.dart';

class HtlibBottomBarNotifier extends ChangeNotifier {
  bool expand = false;
  void setExpand(bool value) {
    expand = value;
    notifyListeners();
  }
}
