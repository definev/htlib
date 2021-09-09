import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';

import 'package:htlib/prod_app.dart';
import 'package:htlib/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  if (!GetPlatform.isDesktop) await Firebase.initializeApp();
  await configureDependencies(mode: "Prod");

  runApp(ProviderScope(child: HtlibApp()));
}
