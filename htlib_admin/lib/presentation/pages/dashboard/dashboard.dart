import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:htlib_admin/application/bloc/book/dashboard/dashboard_bloc.dart';
import 'package:htlib_admin/application/bloc/book/dashboard/main_screen/book_list_view/book_list_view_cubit.dart';
import 'package:htlib_admin/application/bloc/book/dashboard/main_screen/search_bar/search_bar_cubit.dart';
import 'package:htlib_admin/presentation/shared/constant.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:htlib_admin/presentation/pages/dashboard/components/book_detail_drawer.dart';
import 'package:htlib_admin/presentation/pages/dashboard/components/main_screen.dart';
import 'package:htlib_admin/presentation/pages/dashboard/components/menu_drawer.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: Container(color: Colors.blue),
      tablet: Container(color: Colors.yellow),
      desktop: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              MenuDrawer(),
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  return state.when<Widget>(
                    dataFailure: (errCode) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "$errCode",
                            style: HTlibTextStyle.headline6Text,
                          ),
                        ),
                      );
                    },
                    initial: () {
                      context
                          .watch<DashboardBloc>()
                          .add(DashboardEvent.getBookList());

                      return Expanded(
                        child: Center(
                          child: SizedBox(
                            height: 250.0,
                            width: 250.0,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    },
                    successGetBookList: (bookList) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(create: (context) => SearchBarCubit()),
                          BlocProvider(
                              create: (context) => BookListViewCubit()),
                        ],
                        child: MainScreen(bookList: bookList),
                      );
                    },
                  );
                },
              ),
              BookDetailDrawer(),
            ],
          ),
        ),
      ),
      watch: Container(color: Colors.purple),
    );
  }
}
