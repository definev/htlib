import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:htlib/app.dart';
import 'package:htlib/injection.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!GetPlatform.isWeb && GetPlatform.isDesktop) {
    setWindowTitle('App title');
    setWindowMinSize(Size(454.0, 700.0));
    setWindowMaxSize(Size.infinite);
  }

  if (GetPlatform.isMobile) await Firebase.initializeApp();

  await configureDependencies();

  runApp(HtlibApp());
}
