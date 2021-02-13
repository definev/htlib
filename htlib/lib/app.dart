import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:htlib/src/view/book_management/book_management_screen.dart';
import 'package:htlib/src/view/home/home_screen.dart';
import 'package:htlib/src/view/user_management/user_management_screen.dart';

class HtlibApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexColorScheme.light(scheme: FlexScheme.bigStone).toTheme,
      initialRoute: HomeScreen.route,
      routes: {
        HomeScreen.route: (context) => HomeScreen(),
        BookManagementScreen.route: (context) => BookManagementScreen(),
        UserManagementScreen.route: (context) => UserManagementScreen(),
      },
    );
  }
}
