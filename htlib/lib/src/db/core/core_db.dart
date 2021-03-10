import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

abstract class CoreDb<T> {
  final String tableName;
  Box<T> box;

  CoreDb(this.tableName) {
    init();
  }

  bool disable = false;

  @mustCallSuper
  Future<void> init({bool disable = false}) async {
    this.disable = disable;
    if (box == null) {
      box = await Hive.openBox(tableName);
    }
  }

  dynamic read(String key) => disable ? null : box.get(key);

  void write(String key, T value) => disable ? null : box.put(key, value);

  void delete(String key) => disable ? null : box.delete(key);
}
