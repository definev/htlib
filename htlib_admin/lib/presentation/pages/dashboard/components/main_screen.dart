import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:htlib_admin/application/bloc/book/dashboard/main_screen/search_bar/search_bar_cubit.dart';
import 'package:htlib_admin/domain/book/entities/book.dart';
import 'package:htlib_admin/presentation/pages/dashboard/components/main_screen/book_list_view.dart';
import 'package:htlib_admin/presentation/pages/dashboard/components/main_screen/search_bar.dart';
import 'package:sized_context/sized_context.dart';

class MainScreen extends StatelessWidget {
  final List<Book> bookList;
  const MainScreen({Key key, this.bookList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Expanded(
          child: GestureDetector(
            onTap: () => context.read<SearchBarCubit>().unFocusText(context),
            child: Container(
              height: context.heightPx,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 68.5),
              child: Column(
                children: [
                  SearchBar(),
                  BookListView(bookList: bookList),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
