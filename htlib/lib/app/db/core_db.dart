import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

abstract class CoreDb {
  final String tableName;
  List<TypeAdapter> adapter = [];
  Box box;

  CoreDb(this.tableName, {this.adapter}) {
    init();
  }

  @mustCallSuper
  Future<void> init() async {
    adapter.forEach((apt) {
      if (!Hive.isAdapterRegistered(apt.typeId)) Hive.registerAdapter(apt);
    });
    box = await Hive.openBox(tableName);
  }

  dynamic read(dynamic key) => box.get(key);

  void write(dynamic key, dynamic value) => box.put(key, value);

  void delete(dynamic key) => box.delete(key);
}
