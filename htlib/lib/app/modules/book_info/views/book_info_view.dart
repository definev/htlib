import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:htlib/styled_components/buttons/menu_button.dart';
import 'package:htlib/styled_components/buttons/primary_btn.dart';
import 'package:htlib/styled_components/styled_custom_icon.dart';

import 'package:styled_widget/styled_widget.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/utils/build_utils.dart';

import 'package:htlib/app/modules/book_info/controllers/book_info_controller.dart';
import 'package:htlib/styled_components/styled_container.dart';
import 'package:htlib/styles.dart';

class BookInfoView extends GetView<BookInfoController> {
  @override
  Widget build(BuildContext context) {
    controller.context = context;

    return Scaffold(
      body: StyledContainer(
        Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (context.width <= PageBreaks.TabletPortrait)
                          Row(children: [MenuButton(), HSpace(Insets.m)]),
                        PrimaryTextBtn(
                          "Quay lại",
                          onPressed: controller.backToDashboard,
                        ),
                      ],
                    ),
                    TextStyles.T1Text("Thông tin sách", color: Colors.black),
                  ],
                ).paddingOnly(bottom: Insets.m),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => BuildUtils.getResponsive(
                            context,
                            desktop: AnimatedContainer(
                              duration: Durations.medium,
                              height: 464 - 36.0,
                              width: 464 - 36.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color:
                                      controller.appTheme.value.accent1Darker,
                                  width: 3,
                                ),
                                color: Colors.white,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Feather.book_open,
                                size: FontSizes.s200,
                                color: Colors.black,
                              ),
                            ),
                            mobile: Expanded(
                              child: AnimatedContainer(
                                duration: Durations.medium,
                                height: 464 - 36.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color:
                                        controller.appTheme.value.accent1Darker,
                                    width: 3,
                                  ),
                                  color: Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Feather.book_open,
                                  size: FontSizes.s200,
                                  color: Colors.black,
                                ),
                              ).marginOnly(
                                  bottom:
                                      context.width <= PageBreaks.TabletPortrait
                                          ? Insets.l
                                          : 0),
                            ),
                            tablet: AnimatedContainer(
                              duration: Durations.medium,
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color:
                                      controller.appTheme.value.accent1Darker,
                                  width: 3,
                                ),
                                color: Colors.white,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Feather.book_open,
                                size: FontSizes.s200,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        if (context.width >= PageBreaks.TabletPortrait)
                          controller
                              .bookDesc()
                              .paddingOnly(left: Insets.xl)
                              .expanded()
                      ],
                    ),
                    if (context.width <= PageBreaks.TabletPortrait)
                      controller.bookDesc()
                  ],
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: Theme(
                data: context.theme.copyWith(
                  tabBarTheme: context.theme.tabBarTheme.copyWith(
                    unselectedLabelColor: Colors.grey,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                          width: 2.0, color: controller.appTheme.value.accent1),
                    ),
                    labelColor: controller.appTheme.value.accent1,
                    labelStyle: TextStyles.T1,
                    unselectedLabelStyle: TextStyles.T1,
                  ),
                ),
                child: DefaultTabController(
                  initialIndex: 0,
                  length: 1,
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) {
                          if (controller.isInit == false) {
                            Future.delayed(Durations.slow, () {
                              controller.tabController =
                                  DefaultTabController.of(context);
                              controller.tabController?.addListener(() {
                                print("CHANGE TAB ");
                                controller.tabIndex.value =
                                    controller.tabController.index;
                              });
                            });
                            controller.isInit = true;
                          }
                          return TabBar(
                            tabs: [
                              Tab(
                                  icon: Obx(
                                    () => StyledCustomIcon(
                                      Feather.users,
                                      color: controller.tabIndex.value == 0
                                          ? context.theme.tabBarTheme.labelColor
                                          : context.theme.tabBarTheme
                                              .unselectedLabelColor,
                                    ),
                                  ),
                                  text: "Người đang mượn sách"),
                            ],
                          );
                        },
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Center(child: Text("SCREEN 1")),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ).paddingAll(Insets.mid),
    )
        .constrained(
          height: context.height,
          width: controller.homeSize,
        )
        .positioned(
          left: BuildUtils.getResponsive(
            context,
            desktop: controller.drawerSize,
            tablet: controller.drawerSize,
            mobile: 0,
          ),
        );
  }
}
