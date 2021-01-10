import 'dart:convert';

import 'package:htlib_admin/_internal/log.dart';
import 'package:htlib_admin/_internal/universal_file/universal_file.dart';
import 'package:flutter/cupertino.dart';

abstract class AbstractModel extends ChangeNotifier {
  UniversalFile _file;

  void reset([bool notify = true]) {
    copyFromJson({});
    if (notify) notifyListeners();
    scheduleSave();
  }

  void notify() => notifyListeners();

  //Make sure that we don't spam the file systems, cap saves to a max frequency
  bool _isSaveScheduled = false;

  //[SB] This is a helper method
  void scheduleSave() async {
    if (_isSaveScheduled) return;
    _isSaveScheduled = true;
    await Future.delayed(Duration(seconds: 1));
    save();
    _isSaveScheduled = false;
  }

  //Loads a string from disk, and parses it into ourselves.
  Future<void> load() async {
    String string =
        await _file.read().catchError((e, s) => Log.panic(e, stack: s)) ?? "{}";
    if (string != null) {
      copyFromJson(jsonDecode(string));
    }
  }

  Future<void> save() async => _file.write(jsonEncode(toJson()));

  //Enable file serialization, remember to override the to/from serialization methods as well
  void enableSerialization(String fileName) {
    _file = UniversalFile(fileName);
  }

  Map<String, dynamic> toJson() {
    // This should be over-ridden in concrete class to enable serialization
    throw UnimplementedError();
  }

  dynamic copyFromJson(Map<String, dynamic> json) {
    // This should be over-ridden in concrete class to enable serialization
    throw UnimplementedError();
  }

  List<T> toList<T>(dynamic json, Function(dynamic) fromJson) {
    final List<T> list = (json as Iterable)?.map((e) {
      return e == null ? null : fromJson(e) as T;
    })?.toList();
    return list;
  }
}
