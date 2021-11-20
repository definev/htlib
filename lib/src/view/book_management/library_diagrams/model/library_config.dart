import 'package:flutter/material.dart';

class LibraryConfig extends ChangeNotifier {
  double height;
  double width;
  double size;
  double borderRadius = 20.0;

  LibraryConfig(this.height, this.width, this.size);

  void changeHeight(double value) {
    height = value;
    notifyListeners();
  }

  void changeWidth(double value) {
    width = value;
    notifyListeners();
  }

  void changeSize(double value) {
    size = value;
    notifyListeners();
  }

  void changeBorderRadius(double value) {
    borderRadius = value;
    notifyListeners();
  }
}
