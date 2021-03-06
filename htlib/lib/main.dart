import 'package:desktop_window/desktop_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:htlib/app.dart';
import 'package:htlib/injection.dart';

Future<void> windowConfig() async {
  // await DesktopWindow.setMinWindowSize(Size(500, 800));

  await DesktopWindow.setFullScreen(true);
  // await DesktopWindow.resetMaxWindowSize();
  // await DesktopWindow.toggleFullScreen();
  // bool isFullScreen = await DesktopWindow.getFullScreen();
  // await DesktopWindow.setFullScreen(true);
  // await DesktopWindow.setFullScreen(false);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!GetPlatform.isDesktop) await Firebase.initializeApp();
  await configureDependencies();

  runApp(HtlibApp());
  // if (GetPlatform.isWindows) await windowConfig();
}
