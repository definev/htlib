import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:htlib_admin/commands/bootstrap_command.dart';
import 'package:htlib_admin/data/theme/theme_type.dart';
import 'package:htlib_admin/services/book_service.dart';
import 'package:htlib_admin/themes.dart';
import 'package:htlib_admin/views/add_book/home.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_size/window_size.dart' as ws;

main() {
  /// Need to add this in order to run on Desktop. See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  if (UniversalPlatform.isWindows ||
      UniversalPlatform.isLinux ||
      UniversalPlatform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    ws.setWindowTitle('Thư viện THPT Hàn Thuyên');
  }

  runApp(HtlibApp());
}

class HtlibApp extends StatefulWidget {
  @override
  _HtlibAppState createState() => _HtlibAppState();
}

class _HtlibAppState extends State<HtlibApp> {
  @override
  void initState() {
    super.initState();
    BootstrapCommand(context).execute();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.fromType(ThemeType.BlueHT);

    return MultiProvider(
      providers: [
        Provider.value(value: theme),

        /// SERVICE
        Provider.value(value: BookService.instance),
      ],
      child: Home(),
    );
  }
}
