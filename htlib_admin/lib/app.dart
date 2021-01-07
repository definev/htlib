import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:htlib_admin/application/bloc/book/dashboard/dashboard_bloc.dart';
import 'package:htlib_admin/injection.dart';
import 'package:htlib_admin/presentation/pages/dashboard/dashboard.dart';
import 'package:htlib_admin/presentation/shared/constant.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil().init(constraints, Orientation.portrait);

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: HTlibColorTheme.htlibTheme,
              home: BlocProvider.value(
                value: getIt<DashboardBloc>(),
                child: Dashboard(),
              ),
            );
          },
        );
      },
    );
  }
}
