import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/_internal/utils/utils.dart';
import 'package:htlib/src/model/book.dart';
import 'package:htlib/src/services/book_service.dart';
import 'package:htlib/src/services/state_management/core/cubit_list/cubit/list_cubit.dart';
import 'package:htlib/src/view/book_management/components/classify_book/classify_book_tile.dart';

class ClassifyBookScreen extends StatefulWidget {
  @override
  _ClassifyBookScreenState createState() => _ClassifyBookScreenState();
}

class _ClassifyBookScreenState extends State<ClassifyBookScreen> {
  Map<String, List<Book>> _classifyList = {};

  BookService bookService = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCubit<Book>, ListState>(
      bloc: bookService.bookListCubit,
      builder: (context, state) {
        Utils.benchmark("Classify Book", () {
          _classifyList = {};
          bookService.classifyTypeList.forEach((type) {
            _classifyList
                .addEntries([MapEntry(type, bookService.getListByType(type))]);
          });
          _classifyList.removeWhere((key, value) => value == <Book>[]);
        });
        return SliverGrid.count(
          crossAxisCount: _classifyList.length == 1
              ? 1
              : PageBreak.defaultPB.isDesktop(context)
                  ? 3
                  : PageBreak.defaultPB.isTablet(context)
                      ? 2
                      : 1,
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
          children: _classifyList
              .map<String, Widget>((key, value) {
                return MapEntry(
                  key,
                  ClassifyBookTile(type: key, bookList: value),
                );
              })
              .values
              .toList(),
        );
      },
    );
  }
}
