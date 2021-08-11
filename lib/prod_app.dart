import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/view/book_management/book_management_screen.dart';
import 'package:htlib/src/view/home/home_screen.dart';
import 'package:htlib/src/view/login_screen.dart';
import 'package:htlib/src/view/settings/setting_screen.dart';
import 'package:htlib/src/view/user_management/user_management_screen.dart';
import 'package:htlib/styles.dart';

class HtlibApp extends StatefulWidget {
  @override
  _HtlibAppState createState() => _HtlibAppState();
}

class _HtlibAppState extends State<HtlibApp> {
  late StreamSubscription _themeSubscription;
  late StreamSubscription _buttonModeSubscription;
  HtlibDb db = Get.find();
  late ThemeData _theme;
  int? _buttonMode;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _theme = (db.config.themeMode == 0 ? FlexColorScheme.light(scheme: FlexScheme.values[db.config.theme]) : FlexColorScheme.dark(scheme: FlexScheme.values[db.config.theme])).toTheme;

    _buttonMode = db.config.buttonMode;
    _themeSubscription = db.config.themeSubscribe().listen((event) {
      _theme = (db.config.themeMode == 0 ? FlexColorScheme.light(scheme: FlexScheme.values[db.config.theme]) : FlexColorScheme.dark(scheme: FlexScheme.values[db.config.theme])).toTheme;
      setState(() {});
    });
    _buttonModeSubscription = db.config.buttonModeSubscribe().listen(
      (event) {
        _buttonMode = event;
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _themeSubscription.cancel();
    _buttonModeSubscription.cancel();
    super.dispose();
  }

  OutlinedBorder shape() => _buttonMode == 0 ? RoundedRectangleBorder(borderRadius: Corners.s7Border) : BeveledRectangleBorder(borderRadius: Corners.s10Border);

  ButtonStyle buttonStyle() => ButtonStyle(shape: MaterialStateProperty.all(shape()));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale('vi', 'VN'),
      supportedLocales: [const Locale('vi', 'VN')],
      theme: _theme.copyWith(
        // accentColor: Colors.transparent,
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
          headline4: TextStyles.Headline4.copyWith(color: _theme.colorScheme.onBackground),
          headline5: TextStyles.Headline5.copyWith(color: _theme.colorScheme.onBackground),
          headline6: TextStyles.Headline6.copyWith(color: _theme.colorScheme.onBackground),
          button: TextStyles.Button,
          bodyText1: TextStyles.Body1.copyWith(color: _theme.colorScheme.onBackground),
          bodyText2: TextStyles.Body2.copyWith(color: _theme.colorScheme.onBackground),
          subtitle1: TextStyles.Subtitle1.copyWith(color: _theme.colorScheme.onBackground),
          subtitle2: TextStyles.Subtitle2.copyWith(color: _theme.colorScheme.onBackground),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle()),
        floatingActionButtonTheme: FloatingActionButtonThemeData(shape: shape()),
        outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle()),
        textButtonTheme: TextButtonThemeData(style: buttonStyle()),
        cardTheme: CardTheme(shape: shape()),
        appBarTheme: AppBarTheme(titleTextStyle: TextStyles.Headline6.copyWith(color: _theme.colorScheme.onPrimary)),
      ),
      scrollBehavior: CupertinoScrollBehavior(),
      initialRoute: "/",
      routes: {
        "/": (_) => (FirebaseAuth.instance.currentUser != null) ? HomeScreen() : LoginScreen(),
        LoginScreen.route: (context) {
          if (FirebaseAuth.instance.currentUser != null) return HomeScreen();
          return LoginScreen();
        },
        HomeScreen.route: (context) {
          if (FirebaseAuth.instance.currentUser == null) return LoginScreen();
          return HomeScreen();
        },
        BookManagementScreen.route: (context) {
          if (FirebaseAuth.instance.currentUser == null) return LoginScreen();
          return BookManagementScreen();
        },
        UserManagementScreen.route: (context) {
          if (FirebaseAuth.instance.currentUser == null) return LoginScreen();
          return UserManagementScreen();
        },
        SettingScreen.route: (context) {
          if (FirebaseAuth.instance.currentUser == null) return LoginScreen();
          return SettingScreen();
        },
      },
    );
  }
}
