import 'package:htlib_admin/app.dart';
import 'package:flutter/material.dart';
import 'package:htlib_admin/injection.dart';
import 'package:injectable/injectable.dart';

void prodMain() {
  configurationInjection(Environment.prod);
  runApp(MyApp());
}
