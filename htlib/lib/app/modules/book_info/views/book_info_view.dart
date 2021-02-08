import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:htlib/app/modules/home/controllers/home_controller.dart';
import 'package:htlib/styled_components/buttons/primary_btn.dart';

import 'package:styled_widget/styled_widget.dart';

import 'package:get/get.dart';
import 'package:htlib/_internal/utils/build_utils.dart';

import 'package:htlib/app/modules/book_info/controllers/book_info_controller.dart';
import 'package:htlib/styled_components/styled_container.dart';
import 'package:htlib/styles.dart';

class BookInfoView extends GetView<BookInfoController> {
  @override
  Widget build(BuildContext context) {
    HomeController hCtrl = Get.find();
    controller.context = context;

    return Container(
      color: hCtrl.appTheme.value.bg2,
      width: hCtrl.contentSize(context),
      padding: EdgeInsets.all(Insets.mid),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IgnorePointer(
                      child: Opacity(
                    opacity: 0.0,
                    child: PrimaryBtn(
                      bigMode: true,
                      child: TextStyles.H2Text("Quay lại"),
                      onPressed: controller.backToDashboard,
                    ).clipRRect(bottomLeft: 40, topLeft: 40),
                  )),
                ],
              ).paddingOnly(bottom: Insets.m),
              controller.bookDesc().marginSymmetric(
                    vertical: BuildUtils.getResponsive(
                      context,
                      desktop: Insets.xl,
                      tablet: Insets.l,
                      mobile: Insets.m,
                      tabletPortrait: Insets.mid,
                    ),
                  )
            ],
          ),
          Divider(),
          Obx(
            () => Theme(
              data: context.theme.copyWith(
                accentColor: Colors.transparent,
                focusColor: Colors.black12,
                highlightColor: Colors.grey.withOpacity(0.1),
                tabBarTheme: context.theme.tabBarTheme.copyWith(
                  unselectedLabelColor: Colors.grey,
                  indicator: UnderlineTabIndicator(
                    insets: EdgeInsets.zero,
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
                length: 2,
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        if (controller.isInit == false) {
                          Future.delayed(Durations.slow, () {
                            controller.tabController =
                                DefaultTabController.of(context);
                            controller.tabController?.addListener(() {
                              controller.tabIndex.value =
                                  controller.tabController.index;
                            });
                          });
                          controller.isInit = true;
                        }
                        return TabBar(
                          tabs: [
                            Tab(
                                icon: Icon(Feather.users),
                                text: "Người đang mượn sách"),
                            Tab(
                                icon: Icon(Feather.file_text),
                                text: "Lịch sử cho mượn"),
                          ],
                          onTap: (value) {},
                        );
                      },
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Center(child: Text("SCREEN 1")),
                          Center(child: Text("SCREEN 1")),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ).constrained(maxWidth: PageBreaks.TabletPortrait).expanded(),
        ],
      ),
    );
  }
}
