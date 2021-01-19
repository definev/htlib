import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/styles.dart';
import 'package:pluto_grid/pluto_grid.dart';

class SearchBarView extends GetView {
  final PlutoGridStateManager stateManager;

  SearchBarView(this.stateManager);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          TextStyles.T1Text("${stateManager}"),
        ],
      ),
    );
  }
}
