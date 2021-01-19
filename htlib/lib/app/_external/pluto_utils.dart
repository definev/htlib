import 'package:pluto_grid/pluto_grid.dart';

class PlutoUtils {
  static PlutoGridLocaleText get vie {
    return PlutoGridLocaleText(
      // Menu cột
      unfreezeColumn: 'Bỏ khóa cột',
      freezeColumnToLeft: 'Cố định cột sang trái',
      freezeColumnToRight: 'Cố định cột sang phải',
      autoFitColumn: 'Tự động điều chỉnh',
      setFilter: 'Đặt bộ lọc',
      resetFilter: 'Đặt lại bộ lọc',
      // Lọc cửa sổ bật lên
      filterColumn: 'Cột',
      filterType: 'Loại',
      filterValue: 'Giá trị',
      filterAllColumns: 'Tất cả các cột',
      filterContains: 'Chứa',
      filterEquals: 'Bằng',
      filterStartsWith: 'Bắt ​​đầu với',
      filterEndsWith: 'Kết thúc bằng',
      filterGreaterThan: 'Lớn hơn',
      filterGreaterThanOrEqualTo: 'Lớn hơn hoặc bằng',
      filterLessThan: 'Nhỏ hơn',
      filterLessThanOrEqualTo: 'Nhỏ hơn hoặc bằng',
      // Cửa sổ bật lên ngày
      sunday: 'CN',
      monday: 'Th. 2',
      tuesday: 'Th. 3',
      wednesday: 'Th. 4',
      thursday: 'Th. 5',
      friday: 'Th. 6',
      saturday: 'Th. 7',
      // Cửa sổ bật lên của cột thời gian
      hour: 'Giờ',
      minute: 'Phút',
      // Chung
      loadingText: 'Đang tải ...',
    );
  }
}
