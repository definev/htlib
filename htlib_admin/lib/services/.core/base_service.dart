import 'package:hive/hive.dart';
import 'package:htlib_admin/services/.core/abstract_service.dart';

abstract class BaseService<BoxType> extends AbstractService<BoxType> {
  final String _boxName;
  Box<BoxType> _hBox;

  Box<BoxType> get hBox => _hBox;

  BaseService(this._boxName) {
    Future.microtask(_initLocalData);
  }

  void _initLocalData() async {
    Hive.isBoxOpen(_boxName)
        ? _hBox = Hive.box<BoxType>(_boxName)
        : _hBox = await Hive.openBox<BoxType>(_boxName);
  }

  @override
  Future<void> write(String key, BoxType value) async => _hBox.put(key, value);

  @override
  BoxType read(String key) => _hBox.get(key);

  @override
  Future<void> delete(String key) async => _hBox.delete(key);
}
