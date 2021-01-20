import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/utils/build_utils.dart';
import 'package:htlib/_internal/utils/file_utils.dart';
import 'package:htlib/app/data/book_base.dart';
import 'package:htlib/app/db/htlib_db.dart';
import 'package:htlib/app/modules/add_book_base_dialog/controllers/add_book_base_dialog_controller.dart';
import 'package:htlib/app/modules/add_book_base_dialog/views/add_book_base_dialog_view.dart';
import 'package:htlib/app/modules/dashboard/views/row_function_column.dart';
import 'package:htlib/app/repositories/htlib_repos.dart';
import 'package:htlib/app/services/excel_service.dart';
import 'package:htlib/themes.dart';

import 'package:pluto_grid/pluto_grid.dart';

class DashboardController extends GetxController {
  BuildContext context;

  double get drawerSize => BuildUtils.getResponsive<double>(
        context,
        desktop: 300,
        tablet: 300,
        mobile: 300,
      );

  double get homeSize => BuildUtils.getResponsive<double>(
        context ?? Get.context,
        desktop: Get.width - 300,
        tablet: Get.width - 300,
        mobile: Get.width,
      );

  double get positionedHome => BuildUtils.getResponsive<double>(
        context,
        desktop: 300,
        tablet: 300,
        mobile: 0,
      );

  Rx<ExcelService> excelService;

  List<BookBase> _bookBaseList = <BookBase>[];

  Rx<List<PlutoRow>> plutoRowBookBaseList = Rx<List<PlutoRow>>([]);
  Rx<AppTheme> appTheme;

  PlutoGridStateManager stateManager;

  double get columnWidth => (homeSize - 269) / 5;

  StreamSubscription<String> _addSyncStream;

  List<PlutoColumn> columns;
  var isInAddSync = false.obs;

  void doAddSync() async {
    isInAddSync.value = !isInAddSync.value;
    if (isInAddSync.value) {
      _addSyncStream = HtlibRepos.excel.getBarcodeStream().listen((isbn) async {
        if (isbn == null) return;
        if (!Get.isDialogOpen) {
          Get.lazyPut(() => AddBookBaseDialogController());
          Get.dialog(AddBookBaseDialogView(isbn)).then(
            (value) {
              BookBase bookBase = value;
              if (bookBase != null) {
                stateManager.appendRows([
                  PlutoRow(
                      cells: bookBase.toPlutoCellMap(stateManager.rows.length)),
                ]);
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
    HtlibDb.book.deleteBookBaseList(_bookBaseList);
    _bookBaseList = [];
    stateManager.removeRows(plutoRowBookBaseList.value);
    plutoRowBookBaseList.value = _bookBaseList.toPlutoRowList();
  }

  Future<void> syncData() async {
    List<BookBase> bookBaseList = await HtlibRepos.excel.getBookBaseList();
    if (bookBaseList.hashCode != _bookBaseList.hashCode) {
      await HtlibRepos.excel.addBookBaseList(_bookBaseList);
      _bookBaseList.addAll(bookBaseList);
      _bookBaseList = _bookBaseList.toSet().toList();
      HtlibDb.book.addBookBaseList(_bookBaseList, override: true);
      plutoRowBookBaseList.value = _bookBaseList.toPlutoRowList();
      stateManager.appendRows(plutoRowBookBaseList.value);
    }
  }

  void getDataFromFile() async {
    var file = await FileUtils.excel();
    if (file != null) {
      excelService = GetPlatform.isWeb
          ? ExcelService.fromUint8List(file).obs
          : ExcelService.fromFile(file).obs;
      _bookBaseList = excelService.value.getBookBaseList();
      HtlibDb.book.addBookBaseList(_bookBaseList, override: true);
      HtlibRepos.excel.addBookBaseList(_bookBaseList);
      if (_bookBaseList.isNotEmpty) {
        plutoRowBookBaseList.value = _bookBaseList.toPlutoRowList();
        stateManager.appendRows(plutoRowBookBaseList.value);
      }
    }
  }

  @override
  void onInit() {
    _bookBaseList = HtlibDb.book.currentBookBaseList;
    plutoRowBookBaseList.value = _bookBaseList.toPlutoRowList();
    appTheme = Get.find();
    columns = [
      PlutoColumn(
        title: "STT",
        field: "stt",
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
        frozen: PlutoColumnFrozen.left,
        width: (homeSize - 269 - 20) / 5,
      ),
      PlutoColumn(
        title: "Mã ISBN",
        field: "isbn",
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
        title: "Nhà xuất bản",
        field: "publisher",
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
        title: "Thể loại",
        field: "type",
        type: PlutoColumnType.text(),
        width: (homeSize - 269 - 20) / 5,
      ),
      PlutoColumn(
        title: "Số lượng",
        field: "quantity",
        type: PlutoColumnType.number(),
        width: (homeSize - 269 - 20) / 5,
      ),
      PlutoColumn(
        title: "Chức năng",
        field: "function",
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        frozen: PlutoColumnFrozen.right,
        renderer: (rendererContext) => RowFunctionColumn(rendererContext),
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
