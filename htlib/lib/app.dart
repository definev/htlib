import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:htlib/src/view/book_management/book_management_screen.dart';
import 'package:htlib/src/view/home/home_screen.dart';
import 'package:htlib/src/view/user_management/user_management_screen.dart';
import 'package:htlib/styles.dart';

class HtlibApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData _theme = FlexColorScheme.light(
      scheme: FlexScheme.custom,
    ).toTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _theme.copyWith(
        accentColor: Colors.transparent,
        focusColor: Colors.black12,
        highlightColor: Colors.grey.withOpacity(0.1),
        tabBarTheme: _theme.tabBarTheme.copyWith(
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
            insets: EdgeInsets.zero,
            borderSide: BorderSide(width: 2.0, color: _theme.primaryColor),
          ),
          labelColor: _theme.primaryColor,
          labelStyle: TextStyles.Subtitle2,
          unselectedLabelStyle: TextStyles.Subtitle2,
        ),
        textTheme: _theme.textTheme.copyWith(
          headline5: TextStyles.Heading5.copyWith(
              color: _theme.colorScheme.onBackground),
          headline6: TextStyles.Heading6.copyWith(
              color: _theme.colorScheme.onBackground),
          bodyText1:
              TextStyles.Body1.copyWith(color: _theme.colorScheme.onBackground),
          bodyText2:
              TextStyles.Body2.copyWith(color: _theme.colorScheme.onBackground),
          subtitle1: TextStyles.Subtitle1.copyWith(
              color: _theme.colorScheme.onBackground),
          subtitle2: TextStyles.Subtitle2.copyWith(
              color: _theme.colorScheme.onBackground),
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 24.0),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
        appBarTheme: AppBarTheme(),
      ),
      initialRoute: HomeScreen.route,
      routes: {
        HomeScreen.route: (context) => HomeScreen(),
        BookManagementScreen.route: (context) => BookManagementScreen(),
        UserManagementScreen.route: (context) => UserManagementScreen(),
      },
    );
  }
}
