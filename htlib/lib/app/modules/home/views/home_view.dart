import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/components/layer_stack.dart';
import 'package:htlib/_internal/components/fading_index_stack.dart';
import 'package:htlib/app/modules/book_management/views/book_management_view.dart';

import 'package:htlib/app/modules/home/controllers/home_controller.dart';
import 'package:htlib/app/modules/home/views/menu_drawer_view.dart';
import 'package:htlib/styles.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    controller.forceCloseDrawerIfInDesktopMode(context);
    return Scaffold(
      key: HomeController.scaffoldKey,
      drawer: MenuDrawerView(true),
      body: LayerStack(
        children: [
          LayerStackElement(
            layerIndex: 0,
            child: MenuDrawerView(false),
          ),
          LayerStackElement(
            layerIndex: 1,
            child: Obx(
              () => FadingIndexedStack(
                duration: Durations.fast,
                index: controller.currentPage.value.index,
                children: [
                  BookManagementView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
