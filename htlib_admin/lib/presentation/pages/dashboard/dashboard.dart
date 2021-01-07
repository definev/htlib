import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:htlib_admin/application/bloc/book/dashboard/dashboard_bloc.dart';
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
        body: Row(
          children: [
            MenuDrawer(),
            BlocConsumer<DashboardBloc, DashboardState>(
              builder: (context, state) {
                state.when<Widget>(
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
                        .read<DashboardBloc>()
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
                    return Expanded(
                      child: ListView.builder(
                        itemCount: bookList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Image.asset(bookList[index].coverImg),
                              Text(
                                "${bookList[index].title}",
                                style: HTlibTextStyle.headline6Text,
                              ),
                              Text(
                                "${bookList[index].desc}",
                                style: HTlibTextStyle.normalText,
                              )
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
                return MainScreen();
              },
              listener: (context, state) {},
            ),
            BookDetailDrawer(),
          ],
        ),
      ),
      watch: Container(color: Colors.purple),
    );
  }
}
