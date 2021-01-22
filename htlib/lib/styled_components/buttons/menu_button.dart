import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/components/fading_index_stack.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/app/modules/home/controllers/home_controller.dart';
import 'package:htlib/themes.dart';

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FadingIndexedStack(
      index: BuildUtils.getResponsive<int>(
        context,
        desktop: 0,
        tablet: 0,
        tabletPortrait: 1,
        mobile: 1,
      ),
      children: [
        Container(),
        Obx(() => Theme(
              data: context.theme.copyWith(
                accentColor: Colors.transparent,
                focusColor: Colors.black12,
                highlightColor: Colors.grey.withOpacity(0.1),
              ),
              child: IconButton(
                icon: Icon(Feather.menu),
                color: Get.find<Rx<AppTheme>>().value.accent1Dark,
                onPressed: () =>
                    HomeController.scaffoldKey?.currentState?.openDrawer(),
              ),
            )),
      ],
    );
  }
}
