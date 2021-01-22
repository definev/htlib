import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/modules/book_info/components/lending_tab/controllers/lending_tab_controller.dart';

class LendingTabView extends GetView<LendingTabController> {
  final BookBase bookBase;

  LendingTabView(this.bookBase);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LendingTabView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LendingTabView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
