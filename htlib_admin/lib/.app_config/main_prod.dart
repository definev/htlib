import 'package:htlib_admin/app.dart';
import 'package:flutter/material.dart';

void prodMain() {
  configurationInjection(Environment.prod);
  runApp(MyApp());
}
