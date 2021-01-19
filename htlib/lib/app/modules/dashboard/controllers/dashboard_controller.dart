import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/db/htlib_db.dart';
import 'package:htlib/app/modules/add_book_base_dialog/controllers/add_book_base_dialog_controller.dart';
import 'package:htlib/app/modules/add_book_base_dialog/views/add_book_base_dialog_view.dart';
import 'package:htlib/app/modules/dashboard/views/check_cell_btn_view.dart';
import 'package:htlib/app/repositories/htlib_repos.dart';
import 'package:htlib/app/services/excel_service.dart';
import 'package:htlib/themes.dart';

import 'package:pluto_grid/pluto_grid.dart';

class DashboardController extends GetxController {
  BuildContext context;

  double get drawerSize {
    return BuildUtils.getResponsive<double>(
      context,
      desktop: 300,
      tablet: 300,
      mobile: 300,
    );
  }

  double get homeSize {
    return BuildUtils.getResponsive<double>(
      context ?? Get.context,
      desktop: Get.width - 300,
      tablet: Get.width - 300,
      mobile: Get.width,
    );
  }

  double get positionedHome {
    return BuildUtils.getResponsive<double>(
      context,
      desktop: 300,
      tablet: 300,
      mobile: 0,
    );
  }

  Rx<ExcelService> excelService;

  Rx<List<BookBase>> _bookBaseList = Rx<List<BookBase>>([]);

  Rx<List<PlutoRow>> plutoRowBookBaseList = Rx<List<PlutoRow>>([]);
  Rx<AppTheme> appTheme;

  PlutoGridStateManager stateManager;

  double get columnWidth => (homeSize - 269) / 5;

  StreamSubscription<int> _addSyncStream;

  List<PlutoColumn> columns;
  var isInAddSync = false.obs;

  void doAddSync() async {
    isInAddSync.value = !isInAddSync.value;
    HtlibRepos.excel.isFirstCall = isInAddSync.value;
    if (isInAddSync.value) {
      _addSyncStream = HtlibRepos.excel.getAddListStream().listen((id) async {
        if (id == null) return;
        if (!Get.isDialogOpen) {
          Get.lazyPut(() => AddBookBaseDialogController());
          Get.dialog(AddBookBaseDialogView(id)).then(
            (value) {
              BookBase bookBase = value;
              if (bookBase != null) {
                stateManager
                    .appendRows([PlutoRow(cells: bookBase.toPlutoCellMap())]);
                stateManager.sortDescending(columns[1]);
              }
            },
          );
        }
      });
    } else {
      _addSyncStream?.cancel();
      await HtlibRepos.excel.deleteAddList();
    }
  }

  void deleteBookBaseList() {
    HtlibDb.book.deleteBookBaseList(_bookBaseList.value);
    _bookBaseList.value = [];
    stateManager.removeRows(plutoRowBookBaseList.value);
    plutoRowBookBaseList.value = _bookBaseList.value.toPlutoRowList();
  }

  Future<void> syncData() async {
    List<BookBase> bookBaseList = await HtlibRepos.excel.getBookBaseList();
    if (bookBaseList.hashCode != _bookBaseList.value.hashCode) {
      await HtlibRepos.excel.addBookBaseList(_bookBaseList.value);
      bookBaseList.addAll(_bookBaseList.value);
      _bookBaseList.value = bookBaseList.toSet().toList();
      HtlibDb.book.addBookBaseList(_bookBaseList.value, override: true);
      plutoRowBookBaseList.value = _bookBaseList.value.toPlutoRowList();
      stateManager.appendRows(plutoRowBookBaseList.value);
    }
  }

  void getDataFromFile() async {
    var file = await FileUtils.excel();
    if (file != null) {
      excelService = GetPlatform.isWeb
          ? ExcelService.fromUint8List(file).obs
          : ExcelService.fromFile(file).obs;
      _bookBaseList = Rx<List<BookBase>>(excelService.value.getBookBaseList());
      HtlibDb.book.addBookBaseList(_bookBaseList.value, override: true);
      HtlibRepos.excel.addBookBaseList(_bookBaseList.value);
      if (_bookBaseList.value.isNotEmpty) {
        plutoRowBookBaseList.value = _bookBaseList.value.toPlutoRowList();
        stateManager.appendRows(plutoRowBookBaseList.value);
      }
    }
  }

  @override
  void onInit() {
    _bookBaseList = Rx(HtlibDb.book.currentBookBaseList);
    plutoRowBookBaseList.value = _bookBaseList.value.toPlutoRowList();
    appTheme = Get.find();
    columns = [
      PlutoColumn(
        title: "Đã mượn",
        field: "checked",
        type: PlutoColumnType.text(defaultValue: ""),
        renderer: (rendererContext) => CheckCellBtnView(rendererContext),
        frozen: PlutoColumnFrozen.right,
        minWidth: 120,
        width: 120,
        enableEditingMode: false,
        enableColumnDrag: false,
      ),
      PlutoColumn(
        title: "ID",
        field: "id",
        type: PlutoColumnType.number(readOnly: true),
        frozen: PlutoColumnFrozen.left,
        width: 100,
        enableFilterMenuItem: true,
        enableEditingMode: false,
        enableColumnDrag: false,
      ),
      PlutoColumn(
        title: "Tên sách",
        field: "name",
        type: PlutoColumnType.text(),
        width: (homeSize - 269 - 20) / 5,
      ),
      PlutoColumn(
        title: "Nơi xuất bản",
        field: "location",
        type: PlutoColumnType.text(),
        width: (homeSize - 269 - 20) / 5,
      ),
      PlutoColumn(
        title: "Năm xuất bản",
        field: "year",
        type: PlutoColumnType.text(),
        width: (homeSize - 269 - 20) / 5,
      ),
      PlutoColumn(
        title: "Giá tiền",
        field: "price",
        type: PlutoColumnType.number(),
        width: (homeSize - 269 - 20) / 5,
      ),
      PlutoColumn(
        title: "Thể loại",
        field: "type",
        type: PlutoColumnType.text(),
        width: (homeSize - 269 - 20) / 5,
      ),
    ];
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
