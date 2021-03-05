import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

abstract class CoreDb<T> {
  final String tableName;
  final List<TypeAdapter> adapter;
  Box<T> box;

  CoreDb(this.tableName, {this.adapter = const []}) {
    init();
  }

  @mustCallSuper
  Future<void> init() async {
    adapter.forEach((apt) {
      if (!Hive.isAdapterRegistered(apt.typeId)) Hive.registerAdapter<T>(apt);
    });
    if (box == null) {
      box = await Hive.openBox(tableName);
    }
  }

  dynamic read(String key) => box.get(key);

  void write(String key, T value) => box.put(key, value);

  void delete(String key) => box.delete(key);
}
