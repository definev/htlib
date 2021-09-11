import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';

import 'package:htlib/prod_app.dart';
import 'package:htlib/injection.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!GetPlatform.isDesktop) await Firebase.initializeApp();
  await configureDependencies(mode: "Prod");

  await SentryFlutter.init(
    (options) => options.dsn = 'https://aba7676fa8ce4be3a905994e0255f047@o994730.ingest.sentry.io/5953385',
    appRunner: () => runApp(ProviderScope(child: HtlibApp())),
  );
}
