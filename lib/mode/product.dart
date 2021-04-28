import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:htlib/prod_app.dart';
import 'package:htlib/injection.dart';
import 'package:htlib/src/db/config_db.dart';
import 'package:htlib/src/db/htlib_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!GetPlatform.isDesktop) await Firebase.initializeApp();
  await configureDependencies(mode: "Prod");

  FirebaseUser user = Get.find<HtlibDb>().config.firebaseUser;
  if (user.isNotEmpty) {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!, password: user.password!);
  }

  runApp(HtlibApp());
}
