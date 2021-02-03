import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/_internal/utils/string_utils.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/modules/book_management/controllers/book_management_controller.dart';
import 'package:htlib/styles.dart';
import 'package:htlib/themes.dart';
import 'package:styled_widget/styled_widget.dart';

class BookInfoController extends GetxController {
  BuildContext context;

  Rx<BookBase> rxBookBase;
  Rx<AppTheme> appTheme = Get.find();
  var tabIndex = 0.obs;

  bool isInit = false;

  TabController tabController;

  Widget _bookElement(String title, String value, {bool showDivider = true}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: TextStyles.T1Text(
                  "$title",
                  color: Colors.black,
                ).center(),
              ),
              VerticalDivider(thickness: 2).constrained(height: 300 / 7),
              Flexible(
                flex: 4,
                child: TextStyles.T1Text(
                  "$value",
                  color: Colors.black,
                ).center(),
              )
            ],
          ),
          (showDivider)
              ? Container(height: 2, color: context.theme.dividerColor)
                  .paddingSymmetric(horizontal: Insets.m)
              : Container(),
        ],
      ).constrained(height: (300 - 2) / 4);

  double get bookDescHeight {
    if (context.height < 730) return (300 - 2) / 4 * 2;
    if (context.height < 850) return (300 - 2) / 4 * 3;
    return 300;
  }

  Widget bookDesc() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedDefaultTextStyle(
            style: TextStyles.H1.copyWith(color: appTheme.value.accent3),
            duration: Durations.fast,
            child: Text(
              "${rxBookBase?.value?.name}",
              textAlign: TextAlign.center,
              maxLines: BuildUtils.specifyForMobile(context,
                  defaultValue: 1, mobile: 2),
              overflow: TextOverflow.ellipsis,
            )
                .constrained(
                  maxWidth: BuildUtils.specifyForMobile(
                    context,
                    defaultValue: PageBreaks.TabletPortrait,
                    mobile: context.width,
                  ),
                )
                .paddingSymmetric(horizontal: Insets.sm),
          ),
          AnimatedContainer(
            duration: Durations.medium,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: appTheme.value.accent1.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 100),
              ],
              border: Border.all(color: context.theme.dividerColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(vertical: Insets.l),
            height: bookDescHeight,
            width: BuildUtils.specifyForMobile(
              context,
              defaultValue: PageBreaks.TabletPortrait,
              mobile: context.width,
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _bookElement("Mã ISBN",
                    "${rxBookBase == null ? "" : rxBookBase.value.isbn}"),
                _bookElement("Giá tiền",
                    "${StringUtils.moneyFormat(rxBookBase == null ? 0 : rxBookBase.value.price)}"),
                _bookElement("Số lượng",
                    "${rxBookBase == null ? "" : rxBookBase.value.quantity}"),
                _bookElement("Nhà xuất bản",
                    "${rxBookBase == null ? "" : rxBookBase.value.publisher}"),
                _bookElement("Năm xuất bản",
                    "${rxBookBase == null ? "" : rxBookBase.value.year}"),
                _bookElement("Thể loại",
                    "${rxBookBase == null ? "" : rxBookBase.value.type}",
                    showDivider: false),
              ],
            ),
          ),
        ],
      );

  void setBookBase(BookBase bookBase) => rxBookBase == null
      ? rxBookBase = bookBase.obs
      : rxBookBase.value = bookBase;

  void backToDashboard() {
    BookManagementController bookManagementController = Get.find();
    bookManagementController.currentScreen.value = 0;
  }

  @override
  void onReady() {
    super.onReady();
  }
}
