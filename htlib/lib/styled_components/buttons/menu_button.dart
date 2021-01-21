import 'package:flutter/material.dart';
import 'package:htlib/_internal/components/fading_index_stack.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/app/modules/home/controllers/home_controller.dart';
import 'package:htlib/styled_components/buttons/primary_btn.dart';

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FadingIndexedStack(
      index: BuildUtils.getResponsive<int>(context,
          desktop: 0, tablet: 0, mobile: 1),
      children: [
        Container(),
        PrimaryTextBtn(
          "Menu",
          onPressed: () =>
              HomeController.scaffoldKey?.currentState?.openDrawer(),
        ),
      ],
    );
  }
}
